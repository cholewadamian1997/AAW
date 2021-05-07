function otsu = hist2otsu(hist)
% Liczenie progu otsu na podstawie histogramu
% 3 problemy w openCL do researchu: 
% #1 suma elementów tablicy? (!!!)
% #2 iloczyn dwóch tablic - wynik skalarny (mozna element po elemencie w 
% pętli, ale konczy sie to problemem #1)
% #3 czy od tablic da się odejmować wartość/mnożyć razy wartość?

% Działania takie jak dzielenie zbiorów czy iloczyn skalarny da się zrobić 
% pętlami
    otsu = 0;
    hist_sum = 0;
    for i=1:length(hist)
        hist_sum=hist_sum+hist(i); 
    end
    hist_norm = hist/hist_sum;

    hist_cumulative = zeros(length(hist_norm),1);
    hist_sum_cumulative = 0;
    for i=1:length(hist_norm)
        hist_sum_cumulative = hist_sum_cumulative+hist_norm(i);
        hist_cumulative(i)=hist_sum_cumulative;
    end

    bins = 1:length(hist);
    fn_min = Inf;

    for i=2:length(hist)
        p1 = hist_norm(1:i-1);
        p2 = hist_norm(i:length(hist));
        q1 = hist_cumulative(i);
        q2 = hist_cumulative(end)-hist_cumulative(i);

    %         ew. warunek continue
        if (q1 < 0.00000001 || q2 < 0.00000001)
            continue
        end
        b1 = bins(1:i-1);
        b2 = bins(i:length(hist));
    %         finding means and variances, dot product used
        m1 = dot(p1,b1)/q1;
        m2 = dot(p2,b2)/q2;
        v1 = dot(((b1-m1).^2),p1)/q1;
        v2 = dot(((b2-m2).^2),p2)/q2;

        fn = v1*q1+v2*q2;
        if (fn < fn_min)
            fn_min = fn;
            otsu = i;
        end
    end
end

