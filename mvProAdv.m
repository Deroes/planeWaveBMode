function [mvData] = mvProAdv(steerData)
%% steerData = transpose(steerData);
N_ele     = size(steerData, 1);      % N_ele/2;

if size(steerData, 2) ~= 1
    
    winlen   = N_ele; %floor(N_ele/2);
    e        = ones(winlen, 1);         %��ʼ����������    
    FR       = zeros(winlen, winlen);
    datatemp = zeros(winlen, 1);
    for kk = 1 : N_ele - winlen + 1
        for i = 1 : 3
            Ftemp    = steerData(kk: kk + winlen - 1, i);
            FR       = FR + Ftemp*(Ftemp');   %winlen*winlen
        end
        datatemp = datatemp + steerData(kk: kk + winlen - 1, 2);
    end
    
else
    
% if N_ele < 30
%     winlen   = N_ele;
%     e        = ones(winlen, 1);         %��ʼ����������
%     FR       = steerData * steerData';
%     datatemp = steerData;
% else
    winlen   = round(N_ele / 2);
    e        = ones(winlen, 1);         %��ʼ����������
    FR       = zeros(winlen, winlen);
    datatemp = zeros(winlen, 1);
    
    for kk = 1 : N_ele - winlen + 1
        Ftemp    = steerData(kk: kk + winlen - 1);
        FR       = FR + Ftemp*(Ftemp');   %winlen*winlen
        datatemp = datatemp + Ftemp;
        
% %         g = sum(Ftemp) * ones(size(Ftemp))/winlen;
        
%         FR       = FR - (sum(Ftemp)/winlen)^2 * ones(size(FR));
    end
% end
end

% R = (FR + BR)/2;
Rfb = FR/(N_ele - winlen + 1);     % winlen*winlen

%% �ԽǼ���
delta = 1/(100 * winlen);         % ��������Ҫ����     delta<1/winlen       
lamda = delta * trace(Rfb);        % �������ӻ������          
%
Rdl   = Rfb + lamda * eye(winlen); % �ԽǼ��غ�Ŀռ�Э�������

%% Ape design
R1 = Rdl\e;
w = (R1)/(transpose(e) * R1);            % winlen*1
% disp(w);
%
if isnan(w)
    w = zeros(winlen,1);
end

%% Beamform  %%%%%%%%%%%%%%%%%%%%%
mvData = (w')*datatemp/(N_ele - winlen + 1); %sum(W*X)

end


