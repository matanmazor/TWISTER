function [ ESS ] = computeESS( vec, max_span )
%compute the effective sample size using Neal's formula from Kass et al., 
%1998. 

vec=reshape(vec,[],1);
sum_of_autocorrelations = 0;
for i=1: max_span
    cur_cor = corr(vec(1:end-i),vec(1+i:end));
    %subjective value, suggested by Kruschke in Kruschke, J. (2014). 
    %Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan. Academic Press.
    if cur_cor >0.05
        sum_of_autocorrelations = sum_of_autocorrelations + cur_cor;
    else
        break
    end
end

ESS = length(vec)/(1+2*sum_of_autocorrelations);
end
