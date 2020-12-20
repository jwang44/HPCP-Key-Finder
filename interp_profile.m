function T = interp_profile(t)
T = zeros(1,36);
T(1)=t(1);
for n=2:36
    if mod(n,3)==1
        T(n)=t(floor(n/3)+1);
    end
end
for n=1:34
    if mod(n,3)==2
        T(n)=T(n-1) * 2/3 + T(n+2) * 1/3;
    end
    if mod(n,3)==0
        T(n)=T(n-2) * 1/3 + T(n+1) * 2/3;
    end
end
T(35) = T(34) * 2/3 + T(1) * 1/3;
T(36) = T(34) * 1/3 + T(1) * 2/3;
T = T/max(T);
end