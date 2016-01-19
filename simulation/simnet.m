% simple networks (beta)
% X is activity, S is saved state
function [X,S]=simnet(S)
nn=2;
step=200;
if isempty(S)
    S=repmat([-65,0.0535,0.5931,0.3190],nn,1);
else
    assert(size(S,1)==nn,'state number not match neuron number');
end
%I=rand(nn,1)*10+0.5;
%W=ones(nn)-eye(nn);
W=[0 0; -20 0];

X=zeros(nn,step);
for si=2:step
    for ni=1:nn
        fI=10+ W(ni,:)*X(:,si-1); % full current input (basic + input from others)
        [V,m,h,n]=hhrun(fI,2,S(ni,1),S(ni,2),S(ni,3),S(ni,4),0);
        S(ni,1)=V(end);
        S(ni,2)=m(end);
        S(ni,3)=h(end);
        S(ni,4)=n(end);
        
        if max(V)>0
            X(ni,si)=1;
        end
    end
end

end