R_ar = zeros(100,1);
for i = 1:100
    vanilla_mcml;
    R_ar(i) = R;
end

R_ar1 = zeros(100,1);
A_ar1 = zeros(100,1);
R_ar2 = zeros(100,1);
A_ar2 = zeros(100,1);
for i = 1:100
    vanilla_mcml;
    R_ar1(i) = R_diff;
    A_ar1(i) = A;

    vanilla_mcml_alt;
    R_ar2(i) = R_diff;
    A_ar2(i) = A;
end


load('RA_comp.mat');
R_ar_a = R_ar1; R_ar_b = R_ar2;
A_ar_a = A_ar1; A_ar_b = A_ar2;

[h_R,p_R] = ttest(R_ar_a,R_ar_b);

figure;
histogram(R_ar_a);
hold on;
histogram(R_ar_b);
title(['Reflectance values under multiple runs. p-value = ', num2str(p_R)]);
legend('(a)', '(b)'); 

[h_A,p_A] = ttest(A_ar_a,A_ar_b);

figure;
histogram(A_ar_a);
hold on;
histogram(A_ar_b);
title(['Absorption values under multiple runs. p-value = ', num2str(p_A)]);
legend('(a)', '(b)');