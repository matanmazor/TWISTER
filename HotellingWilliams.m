function [T] = HotellingWilliams(jk, jh, kh, n)

%     based on Williams, E. J. (1959). The comparison of regression variables. 
%     Journal of the Royal Statistical Society. Series B (Methodological), 396-399.
%     and as cited in Steiger, J. H. (1980). Tests for comparing elements of
%     a correlation matrix. Psychological bulletin, 87(2), 245                                                                                                                 

R = (1 - (jk^2) - (jh^2) - (kh^2)) + (2*jk*jh*kh);
r = 0.5*(jk+jh);
T = (jk - jh) * sqrt(((n-1)*(1+kh))/(2*((n-1)/(n-3))*R + (r^2)*((1-kh)^3)));


end

