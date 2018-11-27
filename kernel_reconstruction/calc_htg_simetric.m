function F=calc_htg_simetric(H,G,Mx,Mz)
M=Mx*Mz;
[HN,HM]=size(H);
Ne=size(G,2);
FF=zeros(Mz,HM/Mz);
FF2=zeros(Mz,HM/Mz);

%OPERAÇÃO H'g
for ind_h=1:HM
    h_m=H(:,ind_h);    
    FF(ind_h)=h_m'*G(:);    
    
    % OPERAÇÃO
    if mod(M,2)==0 || ind_h<HM
        hh=reshape(h_m,HN/Ne,Ne);
        h_mf=flip(hh,2);
        h_mf=h_mf(:);
        FF2(ind_h)=h_mf'*G(:);    
    end
end
F=[FF flip(FF2,2)];
    
    
    
