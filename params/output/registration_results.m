clc, clear, close all
addpath('20180524-mavic-ugv-soybean-eschikon-row3');
addpath('export_fig');

GrTr = load("20180524-mavic-ugv-soybean-eschikon-row3_AffineGroundTruth.txt");
% AffesultsList = fileread("output.txt");
% Files_List = strsplit(AffesultsList,'\n');
% 
% % Ground Truth Variables
% Aff_gt = [ GrTr(1) GrTr(2) GrTr(3); 
%          GrTr(5) GrTr(6) GrTr(7);
%          GrTr(9) GrTr(10) GrTr(11)];
%          
% t_gt = [ GrTr(4) GrTr(8) GrTr(12) ];
% scl_gt = [GrTr(13) GrTr(14)];
% s_gt = scaleFromMatrix(Aff_gt);
% Aff_gt_scl = scaleMatrix(Aff_gt, s_gt);
% 
% Result = [];
% counter = 0;
% 
% for i = 1:length(Files_List) - 200
%       
%    
%    curr_file = load(Files_List{i});
%    
%    
%    %Affine Matrix
%    Aff = [ curr_file(1) curr_file(2) curr_file(3); 
%            curr_file(5) curr_file(6) curr_file(7);
%            curr_file(9) curr_file(10) curr_file(11)];
% 
%    t = [ curr_file(4) curr_file(8) curr_file(12)];
% 
%    scl = [ curr_file(13) curr_file(14) ];
%    scl_noise = [ curr_file(15) curr_file(16) ];
%    transl_noise = [ curr_file(17) curr_file(18) ] ;
%    yaw_noise = curr_file(19);
%    
%    if( norm(scl_noise-1) < 0.05 & norm(transl_noise) < 5.1 & norm(transl_noise) > 4.9 )
%        
%         d_scl_x = scl(1) / scl_gt(1);
%         d_scl_y = scl(2) / scl_gt(2);
% 
%         Aff(1,1) = Aff(1,1)*d_scl_x; Aff(2,1) = Aff(2,1)*d_scl_x; Aff(3,1) = Aff(3,1)*d_scl_x;
%         Aff(1,2) = Aff(1,2)*d_scl_y; Aff(2,2) = Aff(2,2)*d_scl_y; Aff(3,2) = Aff(3,2)*d_scl_y;
% 
%         s = scaleFromMatrix(Aff);
%         Aff_scl = scaleMatrix(Aff,s);
% 
%         diff_A = inv(Aff_scl)*Aff_gt_scl;
%         angle_err = max( 0.005, computeAngle( diff_A ) )
%         scale_err = max( 0.005, norm(s(1:2)-s_gt(1:2)) )
%         transl_err = max( 0.005, norm(t - t_gt) )
%         counter = counter + 1;
%         
%    end
%     
%    
% end





scale_T =      [0.05 0.10 0.15 0.20 0.25 0.75 1 1.25 1.5 1.75 2 2.25 2.5 2.75 3 3.25 3.5 3.75 4 4.25 4.5 4.75 5 5.25 5.5];
scale_yaw =    [0.02 0.04 0.06 0.08 0.10 0.12 0.14 0.16 0.18 0.20 0.23 0.27 0.29 0.32 0.35 0.38 0.4];
 
% vector = [1 1 0.99 0.99 1 1 1 0.99 0.99 1 1 0.98 0.99 1 1 0.99 0.98 0.87 0.76 0.54 0.32 0.17 0.05 0.01 0];
% vector_CPD = [0.96 0.83 0.34 0.12 0.02 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
% vector_ICP = [0.97 0.54 0.07 0.01 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
% fig1 = figure(1);
% plot(scale_T, vector,'LineWidth',3);hold on;
% plot(scale_T, vector_CPD,  'g', 'LineWidth', 3);
% plot(scale_T, vector_ICP, 'r', 'LineWidth', 3);
% grid on;
% lab(1) = xlabel('$ \Delta T[m]$');
% lab(2) = ylabel('$Correct~Registration~Rate[ \% ]$');
% leg1 = legend('Our','CPD','ICP', [340 262 0.2 0.2]);
% set(leg1,'Interpreter','latex');
% set(lab,'Interpreter','latex');
% set(leg1,'FontSize',13);
% set(lab,'FontSize',18);
% set(gca,'XLim',[0.02 5.5],'YLim',[0 1.05]);
% export_fig(['plots/noScale_deltaT','.pdf'], '-pdf','-transparent');
% close all;pause(2);

% vector_y =     [1.00 1.00 0.99 1.00 0.99 0.99 1.00 0.99 0.98 0.99 1.00 0.99 0.98 0.87 0.43 0.18 0.01];
% vector_CPD_y = [0.96 0.98 0.96 0.94 0.95 0.93 0.92 0.87 0.74 0.54 0.32 0.21 0.12 0.05 0.00 0.00 0.00];
% vector_ICP_y = [0.96 0.98 0.96 0.94 0.95 0.93 0.76 0.46 0.23 0.11 0.02 0.01 0.00 0.00 0.00 0.00 0.00];
% fig2 = figure(2); 
% plot(scale_yaw, vector_CPD_y,  'g', 'LineWidth', 3);hold on;
% plot(scale_yaw, vector_y,'LineWidth',3);
% plot(scale_yaw, vector_ICP_y, 'r', 'LineWidth', 3);
% grid on;
% lab(1) = xlabel('$ \Delta \Psi[ rad ]$');
% lab(2) = ylabel('$Correct~Registration~Rate[ \% ]$');
% leg1 = legend('Our','CPD','ICP', [340 262 0.2 0.2]);
% set(leg1,'Interpreter','latex');
% set(lab,'Interpreter','latex');
% set(leg1,'FontSize',13);
% set(lab,'FontSize',18);
% set(gca,'XLim',[0.02 0.4],'YLim',[0 1.05]);
% export_fig(['plots/noScale_deltaYaw','.pdf'], '-pdf','-transparent');
% close all;pause(2);

% vector_ss =     [1.00 0.99 1.00 1.00 0.99 1.00 0.99 1.00 1.00 0.99 1.00 0.98 0.99 1.00 1.00 0.99 0.98 0.89 0.71 0.49 0.51 0.21 0.11 0.02 0.00];
% vector_CPD_ss = [0.96 0.75 0.19 0.11 0.01 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
% vector_ICP_ss = [0.23 0.02 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
% fig3 = figure(1);
% plot(scale_T, vector_ss, 'g', 'LineWidth',3);hold on;
% plot(scale_T, vector_CPD_ss, 'LineWidth', 3);
% plot(scale_T, vector_ICP_ss, 'r', 'LineWidth', 3);
% grid on;
% lab(1) = xlabel('$ \Delta T[m]$');
% lab(2) = ylabel('$Correct~Registration~Rate[ \% ]$');
% leg1 = legend('Ours','CPD','ICP', [340 262 0.2 0.2]);
% set(leg1,'Interpreter','latex');
% set(lab,'Interpreter','latex');
% set(leg1,'FontSize',13);
% set(lab,'FontSize',18);
% set(gca,'XLim',[0.02 5.5],'YLim',[0 1.05]);
% export_fig(['plots/SmallScale_deltaT','.pdf'], '-pdf','-transparent');
% close all;pause(2);
% 
% vector_y_ss =     [1.00 1.00 0.99 1.00 1.00 0.99 0.99 0.99 1.00 0.99 1.00 1.00 0.98 0.83 0.71 0.17 0.02];
% vector_CPD_y_ss = [0.96 0.98 0.96 0.94 0.95 0.85 0.71 0.65 0.32 0.09 0.02 0.01 0.00 0.00 0.00 0.00 0.00];
% vector_ICP_y_ss = [0.33 0.11 0.02 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
% fig4 = figure(2); 
% plot(scale_yaw, vector_y_ss,  'g', 'LineWidth', 3);hold on;
% plot(scale_yaw, vector_CPD_y_ss,'LineWidth',3);
% plot(scale_yaw, vector_ICP_y_ss, 'r', 'LineWidth', 3);
% grid on;
% lab(1) = xlabel('$ \Delta \Psi[ rad ]$');
% lab(2) = ylabel('$Correct~Registration~Rate[ \% ]$');
% leg1 = legend('Ours','CPD','ICP', [240 162 0.2 0.2]);
% set(leg1,'Interpreter','latex');
% set(lab,'Interpreter','latex');
% set(leg1,'FontSize',13);
% set(lab,'FontSize',18);
% set(gca,'XLim',[0.02 0.4],'YLim',[0 1.05]);
% export_fig(['plots/SmallScale_deltaYaw','.pdf'], '-pdf','-transparent');
% close all;pause(2);
% 
% vector_ms =     [1.00 0.99 1.00 0.99 0.99 1.00 1.00 1.00 1.00 0.99 1.00 0.99 1.00 0.99 1.00 0.99 0.98 0.91 0.80 0.43 0.38 0.19 0.12 0.01 0.00];
% vector_CPD_ms = [0.93 0.81 0.13 0.09 0.05 0.01 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
% vector_ICP_ms = [0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
% fig5 = figure(1);
% plot(scale_T, vector_ms,'LineWidth',3);hold on;
% plot(scale_T, vector_CPD_ms,  'g', 'LineWidth', 3);
% plot(scale_T, vector_ICP_ms, 'r', 'LineWidth', 3);
% grid on;
% lab(1) = xlabel('$ \Delta T[m]$');
% lab(2) = ylabel('$Correct~Registration~Rate[ \% ]$');
% leg1 = legend('Our','CPD','ICP', [340 260 0.2 0.2]);
% set(leg1,'Interpreter','latex');
% set(lab,'Interpreter','latex');
% set(leg1,'FontSize',16);
% set(lab,'FontSize',16);
% set(gca,'XLim',[0.02 5.5],'YLim',[0 1.05]);
% export_fig(['plots/MediumScale_deltaT','.pdf'], '-pdf','-transparent');
% close all;pause(2);
% 
% vector_y_ms =     [1.00 1.00 0.99 1.00 1.00 1.00 1.00 0.98 1.00 0.99 1.00 0.99 0.99 0.87 0.67 0.16 0.01];
% vector_CPD_y_ms = [0.96 0.93 0.87 0.69 0.45 0.31 0.19 0.06 0.01 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
% vector_ICP_y_ms = [0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
% fig6 = figure(2); 
% plot(scale_yaw, vector_CPD_y_ms,  'g', 'LineWidth', 3);hold on;
% plot(scale_yaw, vector_y_ms,'LineWidth',3);
% plot(scale_yaw, vector_ICP_y_ms, 'r', 'LineWidth', 3);
% grid on;
% lab(1) = xlabel('$ \Delta \Psi[ rad ]$');
% lab(2) = ylabel('$Correct~Registration~Rate[ \% ]$');
% leg1 = legend('Our','CPD','ICP', [340 260 0.2 0.2]);
% set(leg1,'Interpreter','latex');
% set(lab,'Interpreter','latex');
% set(leg1,'FontSize',16);
% set(lab,'FontSize',16);
% set(gca,'XLim',[0.02 0.4],'YLim',[0 1.05]);
% export_fig(['plots/MediumScale_deltaYaw','.pdf'], '-pdf','-transparent');
% close all;pause(2);

% vector_ls =     [1.00 0.99 0.98 0.97 0.96 0.96 0.97 0.91 0.99 0.99 0.98 0.99 1.00 0.99 1.00 0.99 0.98 0.89 0.73 0.46 0.23 0.10 0.02 0.00 0.00];
% vector_CPD_ls = [0.76 0.21 0.02 0.01 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
% vector_ICP_ls = [0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
% fig7 = figure(1);
% plot(scale_T, vector_ls,'LineWidth',3);hold on;
% plot(scale_T, vector_CPD_ls,  'g', 'LineWidth', 3);
% plot(scale_T, vector_ICP_ls, 'r', 'LineWidth', 3);
% grid on;
% lab(1) = xlabel('$ \Delta T[m]$');
% lab(2) = ylabel('$Correct~Registration~Rate[ \% ]$');
% leg1 = legend('Our','CPD','ICP', [340 260 0.2 0.2]);
% set(leg1,'Interpreter','latex');
% set(lab,'Interpreter','latex');
% set(leg1,'FontSize',16);
% set(lab,'FontSize',16);
% set(gca,'XLim',[0.02 5.5],'YLim',[0 1.05]);
% export_fig(['plots/LargeScale_deltaT','.pdf'], '-pdf','-transparent');
% close all;pause(2);
% 
% vector_y_ls =     [1.00 1.00 0.99 0.98 0.97 0.99 0.98 0.97 0.97 0.99 0.99 0.95 0.85 0.75 0.42 0.03 0.00];
% vector_CPD_y_ls = [0.96 0.73 0.32 0.11 0.06 0.02 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
% vector_ICP_y_ls = [0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
% fig8 = figure(2); 
% plot(scale_yaw, vector_CPD_y_ls,  'g', 'LineWidth', 3);hold on;
% plot(scale_yaw, vector_y_ls,'LineWidth',3);
% plot(scale_yaw, vector_ICP_y_ls, 'r', 'LineWidth', 3);
% grid on;
% lab(1) = xlabel('$ \Delta \Psi[ rad ]$');
% lab(2) = ylabel('$Correct~Registration~Rate[ \% ]$');
% leg1 = legend('Our','CPD','ICP', [340 260 0.2 0.2]);
% set(leg1,'Interpreter','latex');
% set(lab,'Interpreter','latex');
% set(leg1,'FontSize',16);
% set(lab,'FontSize',16);
% set(gca,'XLim',[0.02 0.4],'YLim',[0 1.05]);
% export_fig(['plots/LargeScale_deltaYaw','.pdf'], '-pdf','-transparent');
% close all;pause(2);

% vector_xls =     [0.95 0.96 0.93 0.94 0.91 0.93 0.92 0.89 0.90 0.94 0.93 0.96 0.91 0.92 0.87 0.83 0.72 0.76 0.56 0.19 0.09 0.01 0.00 0.00 0.00];
% vector_CPD_xls = [0.21 0.11 0.01 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
% vector_ICP_xls = [0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
% fig9 = figure(1);
% plot(scale_T, vector_xls, 'g', 'LineWidth', 3);hold on;
% plot(scale_T, vector_CPD_xls, 'LineWidth', 3);
% plot(scale_T, vector_ICP_xls, 'r', 'LineWidth', 3);
% grid on;
% lab(1) = xlabel('$ \Delta T[m]$');
% lab(2) = ylabel('$Correct~Registration~Rate[ \% ]$');
% leg1 = legend('Ours','CPD','ICP', [340 262 0.2 0.2]);
% set(leg1,'Interpreter','latex');
% set(lab,'Interpreter','latex');
% set(leg1,'FontSize',13);
% set(lab,'FontSize',18);
% set(gca,'XLim',[0.02 5.5],'YLim',[0 1.05]);
% export_fig(['plots/ExtraLargeScale_deltaT','.pdf'], '-pdf','-transparent');
% close all;pause(2);
% 
% vector_y_xls =     [0.91 0.93 0.92 0.94 0.94 0.95 0.92 0.89 0.90 0.92 0.93 0.89 0.71 0.51 0.19 0.01 0.00];
% vector_CPD_y_xls = [0.86 0.23 0.08 0.01 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
% vector_ICP_y_xls = [0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
% fig10 = figure(2); 
% plot(scale_yaw, vector_y_xls,  'g', 'LineWidth', 3);hold on;
% plot(scale_yaw, vector_CPD_y_xls,'LineWidth',3);
% plot(scale_yaw, vector_ICP_y_xls, 'r', 'LineWidth', 3);
% grid on;
% lab(1) = xlabel('$ \Delta \Psi[ rad ]$');
% lab(2) = ylabel('$Correct~Registration~Rate[ \% ]$');
% leg1 = legend('Ours','CPD','ICP', [340 262 0.2 0.2]);
% set(leg1,'Interpreter','latex');
% set(lab,'Interpreter','latex');
% set(leg1,'FontSize',13);
% set(lab,'FontSize',18);
% set(gca,'XLim',[0.02 0.4],'YLim',[0 1.05]);
% export_fig(['plots/ExtraLargeScale_deltaYaw','.pdf'], '-pdf','-transparent');
% close all;pause(2);

vector_xxls =     [0.82 0.73 0.71 0.83 0.84 0.62 0.74 0.72 0.69 0.58 0.62 0.45 0.29 0.34 0.22 0.12 0.03 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
vector_CPD_xxls = [0.05 0.01 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
vector_ICP_xxls = [0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
fig11 = figure(1);
plot(scale_T, vector_xxls, 'g', 'LineWidth',3);hold on;
plot(scale_T, vector_CPD_xxls,  'LineWidth', 3);
plot(scale_T, vector_ICP_xxls, 'r', 'LineWidth', 3);
grid on;
lab(1) = xlabel('$ \Delta T[m]$');
lab(2) = ylabel('$Correct~Registration~Rate[ \% ]$');
leg1 = legend('Ours','CPD','ICP', [340 262 0.2 0.2]);
set(leg1,'Interpreter','latex');
set(lab,'Interpreter','latex');
set(leg1,'FontSize',13);
set(lab,'FontSize',18);
set(gca,'XLim',[0.02 5.5],'YLim',[0 1.05]);
export_fig(['plots/ExtraExtraLargeScale_deltaT','.pdf'], '-pdf','-transparent');
close all;pause(2);

vector_y_xxls =     [0.82 0.78 0.69 0.71 0.69 0.66 0.60 0.49 0.56 0.29 0.32 0.19 0.05 0.00 0.00 0.00 0.00];
vector_CPD_y_xxls = [0.02 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
vector_ICP_y_xxls = [0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
fig12 = figure(2); 
plot(scale_yaw, vector_y_xxls,  'g', 'LineWidth', 3);hold on;
plot(scale_yaw, vector_CPD_y_xxls,'LineWidth',3);
plot(scale_yaw, vector_ICP_y_xxls, 'r', 'LineWidth', 3);
grid on;
lab(1) = xlabel('$ \Delta \Psi[ rad ]$');
lab(2) = ylabel('$Correct~Registration~Rate[ \% ]$');
leg1 = legend('Ours','CPD','ICP', [340 262 0.2 0.2]);
set(leg1,'Interpreter','latex');
set(lab,'Interpreter','latex');
set(leg1,'FontSize',13);
set(lab,'FontSize',18);
set(gca,'XLim',[0.02 0.4],'YLim',[0 1.05]);
export_fig(['plots/ExtraExtraLargeScale_deltaYaw','.pdf'], '-pdf','-transparent');
close all;pause(2);

function B = scaleMatrix(A,s)
    B = zeros(3,3);
    B(1,1) = A(1,1)/s(1); B(1,2) = A(1,2)/s(2); B(1,3) = A(1,3)/s(3);
    B(2,1) = A(2,1)/s(1); B(2,2) = A(2,2)/s(2); B(2,3) = A(2,3)/s(3);
    B(3,1) = A(3,1)/s(1); B(3,2) = A(3,2)/s(2); B(3,3) = A(3,3)/s(3);
end

function s = scaleFromMatrix(A)
    s = zeros(3,1);
    s(1) = sqrt( A(1,1)*A(1,1) + A(2,1)*A(2,1) + A(3,1)*A(3,1) );
    s(2) = sqrt( A(1,2)*A(1,2) + A(2,2)*A(2,2) + A(3,2)*A(3,2) );
    s(3) = sqrt( A(1,3)*A(1,3) + A(2,3)*A(2,3) + A(3,3)*A(3,3) );
end

function alpha = computeAngle(A)
    alpha = acos( min(1, max(-1, (trace(A) - 1)/2) ) ); 
end