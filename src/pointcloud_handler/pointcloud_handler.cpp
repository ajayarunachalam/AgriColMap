#include "pointcloud_handler.h"

void PointCloudHandler::loadCloud(const std::string &cloud_name, const std::string &cloud_path, const std::string &cloud_key){

    // Check for the fixed cloud path
    string input_pcl_str = _package_path + "/maps/" + cloud_path + "/" + cloud_name + ".ply";
    ifstream input_pcl( input_pcl_str );
    if(!input_pcl)
        ExitWithErrorMsg("File Does Not Exist: " + input_pcl_str);

    _pclMap.emplace( cloud_key, boost::make_shared<PointCloud>(cloud_key) );
    pcl::PointCloud<pcl::PointXYZRGB>::Ptr _pcl_data( new pcl::PointCloud<pcl::PointXYZRGB> );
    pcl::io::loadPLYFile<pcl::PointXYZRGB> ( input_pcl_str, *_pcl_data);
    _pclMap[cloud_key]->loadFromPcl(_pcl_data);
    cerr << FGRN("Correctly Imported: ") << input_pcl_str << " " << _pclMap[cloud_key]->getSize() << " Points" << "\n";

    // Reading the fixed Offset
    string fixed_offset;
    ifstream fixed_offset_file( _package_path + "/maps/" + cloud_path + "/" + "offset.xyz" );
    getline(fixed_offset_file, fixed_offset);
    vector<double> fixed_utm_vec = vectorFromString(fixed_offset);
    _pclMap[ cloud_key ]->setInitGuessT( Vector3d(fixed_utm_vec[0], fixed_utm_vec[1], fixed_utm_vec[2]) );
    _pclMap[ cloud_key ]->setInitGuessQ( Vector3(fixed_utm_vec[3], fixed_utm_vec[4], fixed_utm_vec[5]) );

    if(_verbosity){
        cerr << FYEL("Initial Guess T Correctly Imported: ") << _pclMap[cloud_key]->getInitGuessT().transpose() << "\n";
        cerr << FYEL("Initial Guess Q Correctly Imported: ") << _pclMap[cloud_key]->getInitGuessQ().transpose() << "\n" << "\n";
    }

    Vector3 mean(0.f, 0.f, 0.f);
    for(unsigned int i = 0; i < _pclMap[cloud_key]->getSize(); ++i)
        mean += _pclMap[cloud_key]->getPointCloudAt(i).getVector3fMap();
    mean /= _pclMap[cloud_key]->getSize();

    Transform norm_T( Transform::Identity() );
    norm_T.translation() << -mean;
    _pclMap[cloud_key]->transformPointCloud(norm_T);

}

void PointCloudHandler::initFromYaml(const std::string& yaml_file){

    cerr << FBLU("Initializing from:") << " " << yaml_file << "\n" << "\n";
    YAML::Node configuration = YAML::LoadFile(yaml_file);

    // Loading info for fixed input cloud from YAML
    _fixed_pcl_path = configuration["input_clouds"]["cloud_fixed_path"].as<string>();
    _fixed_pcl = configuration["input_clouds"]["cloud_fixed_name"].as<string>();

    // Check for the fixed cloud path
    string input_pcl = _package_path + "/maps/" + _fixed_pcl_path + "/" + _fixed_pcl + ".ply";
    ifstream in_fixed_pcl( input_pcl );
    if(!in_fixed_pcl)
        ExitWithErrorMsg("File Does Not Exist: " + input_pcl);

    // Loading info for moving input cloud from YAML
    _moving_pcl_path = configuration["input_clouds"]["cloud_moving_path"].as<string>();
    _moving_pcl = configuration["input_clouds"]["cloud_moving_name"].as<string>();

    // Check for the moving cloud path
    input_pcl = _package_path + "/maps/" + _moving_pcl_path + "/" + _moving_pcl + ".ply";
    ifstream mov_fixed_pcl( input_pcl );
    if(!mov_fixed_pcl)
        ExitWithErrorMsg("File Does Not Exist: " + input_pcl);

    // Reading mov_scale
    vector<float> mov_scale_vec = configuration["input_clouds"]["relative_scale"].as<std::vector<float>>();
    _init_mov_scale << mov_scale_vec[0], mov_scale_vec[1];

    _max_iter_num = configuration["aligner_params"]["max_iter_number"].as<int>();
    _verbosity = configuration["aligner_params"]["verbosity"].as<bool>();
    _storeDenseOptFlw = configuration["aligner_params"]["store_dense_optical_flow"].as<bool>();
    _showDOFCorrespondences = configuration["aligner_params"]["show_dpf_correspondences"].as<bool>();
    _dense_optical_flow_step = configuration["aligner_params"]["dense_optical_flow_step"].as<int>();
    _downsampling_rate = configuration["aligner_params"]["downsampling_rate"].as<float>();
    _search_radius = configuration["aligner_params"]["search_radius"].as<float>();
    _useVisualFeatures = configuration["aligner_params"]["use_visual_features"].as<bool>();
    _useGeometricFeatures = configuration["aligner_params"]["use_geometric_features"].as<bool>();

}

void PointCloudHandler::loadFromDisk(const std::string& fixed_cloud_key, const std::string& moving_cloud_key){

    loadCloud(_fixed_pcl, _fixed_pcl_path, fixed_cloud_key);
    loadCloud(_moving_pcl, _moving_pcl_path, moving_cloud_key);

    string ground_truth_tf_path = _package_path + "/params/output/" + _moving_pcl_path + "_AffineGroundTruth.txt";
    ifstream mov_fixed_pcl( ground_truth_tf_path ); bool groundTruth = false;
    if(mov_fixed_pcl) {
        string affine_gt_tf; groundTruth = true;
        getline(mov_fixed_pcl, affine_gt_tf);
        Matrix3 _Rgt; Vector3 _tgt; Vector2 _scl;
        AffineTransformFromString(affine_gt_tf, _Rgt, _tgt, _scl);
        _GTMap.emplace( moving_cloud_key, boost::shared_ptr<GroundTruth>(new GroundTruth(_Rgt, _tgt, _scl)));
    }

    if(_verbosity && groundTruth){
        cerr << FYEL("Ground Truth Affine Matrix: ") << "\n" << _GTMap[moving_cloud_key]->_Rgt << "\n";
        cerr << FYEL("Ground Truth Translation: ") << _GTMap[moving_cloud_key]->_tgt.transpose() << "\n";
        cerr << FYEL("Ground Truth Relative Scale: ") << _GTMap[moving_cloud_key]->_rel_scl.transpose() << "\n" << "\n";
    }

}

void PointCloudHandler::cropFixedPointCloud(const std::string& crop_cloud, const std::string& mov_cloud, const std::string& fix_cloud){

    _pclMap.emplace( crop_cloud, boost::make_shared<PointCloud>( crop_cloud ) );
    std::vector<pcl::PointXYZRGB, Eigen::aligned_allocator<pcl::PointXYZRGB> > filt_pcl;

    Vector2 init_T( _InitTfMap[mov_cloud]->translation().head(2) );

    cerr << FBLU("Cropping Points...") << "\n";
    for( unsigned int i = 0; i < _pclMap[fix_cloud]->getSize(); ++i ) {

        if( ( _pclMap[fix_cloud]->getPointCloudAt(i).getVector3fMap().head(2) - init_T ).norm() < 20.f )
            filt_pcl.push_back( _pclMap[fix_cloud]->getPointCloudAt(i) );

    }

    _pclMap[crop_cloud]->copyFrom(filt_pcl, _pclMap[fix_cloud]->getInitGuessT(), _pclMap[fix_cloud]->getInitGuessQ());
    cerr << FGRN("Cropped Points: ") << _pclMap[fix_cloud]->getSize() - _pclMap[crop_cloud]->getSize() << "\n" << "\n";
}

void PointCloudHandler::loadFixedCloudFromDisk(const std::string &cloud_name, const std::string &cloud_path,
                                               const std::string &cloud_key){

    loadCloud(cloud_name, cloud_path, cloud_key);

    // Normalizing along the Yaw Axis the Fixed Cloud
    Vector3 q =  _pclMap[cloud_key]->getInitGuessQ();
    Transform Rot_z = Transform::Identity();
    Rot_z.rotate( Eigen::AngleAxisf( q(2)*(3.14/180), Vector3::UnitZ() ) );
    _pclMap[cloud_key]->transformPointCloud(Rot_z);

}

void PointCloudHandler::loadMovingCloudFromDisk(const std::string &cloud_name, const std::string &cloud_path,
                                                const std::string &cloud_key, const std::string &fixed_cloud_key, const Vector2 &scale){

    loadCloud(cloud_name, cloud_path, cloud_key);

    Vector3 q = _pclMap[cloud_key]->getInitGuessQ();
    // Normalizing along the Roll and Pitch Axes the Moving Cloud
    Transform Rot_xy = Transform::Identity();
    Rot_xy.rotate( Eigen::AngleAxisf( q(0)*(3.14/180), Vector3::UnitX() ) );
    Rot_xy.rotate( Eigen::AngleAxisf( q(1)*(3.14/180), Vector3::UnitY() ) );
    _pclMap[cloud_key]->transformPointCloud(Rot_xy);

    // Normalizing along the Yaw Axes the Moving Cloud
    Transform Rot_z = Transform::Identity();
    Rot_z.rotate( Eigen::AngleAxisf( q(2)*(3.14/180), Vector3::UnitZ() ) );
    _pclMap[cloud_key]->transformPointCloud(Rot_z);

    cerr << FBLU("InitMovScale Set to: ") << scale.transpose() << "\n";
    _pclMap[cloud_key]->scalePointCloud(scale);

    Vector3d fix_t = getPointCloud(fixed_cloud_key)->getInitGuessT();
    Vector3d mov_t = getPointCloud(cloud_key)->getInitGuessT();
    Vector3d diff_t( mov_t - fix_t );
    _InitTfMap.emplace(cloud_key, boost::shared_ptr<Transform>(new Transform(Transform::Identity())) );
    _InitTfMap[cloud_key]->translation() << diff_t.cast<float>();

    if(_verbosity )
        cerr << FYEL("Init Guess Diff wrt UAV Cloud: ") << diff_t.transpose() << "\n";

    string ground_truth_tf_path = _package_path + "/params/output/" + cloud_path + "_AffineGroundTruth.txt";
    ifstream ground_truth( ground_truth_tf_path ); bool groundTruth = false;
    if(ground_truth) {
        string affine_gt_tf; groundTruth = true;
        getline(ground_truth, affine_gt_tf);
        Matrix3 _Rgt; Vector3 _tgt; Vector2 _scl;
        AffineTransformFromString(affine_gt_tf, _Rgt, _tgt, _scl);
        _GTMap.emplace( cloud_key, boost::shared_ptr<GroundTruth>(new GroundTruth(_Rgt, _tgt, _scl)));
    } else {
        ExitWithErrorMsg("File Does Not Exist: " + ground_truth_tf_path);
    }

    if(_verbosity && groundTruth){
        cerr << FYEL("Ground Truth Affine Matrix: ") << "\n" << _GTMap[cloud_key]->_Rgt << "\n";
        cerr << FYEL("Ground Truth Translation: ") << _GTMap[cloud_key]->_tgt.transpose() << "\n";
        cerr << FYEL("Ground Truth Relative Scale: ") << _GTMap[cloud_key]->_rel_scl.transpose() << "\n" << "\n";
    }
}