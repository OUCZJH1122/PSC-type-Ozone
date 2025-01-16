% OMI
D_TCO = [-33.47; 3.80; -35.74; 3.66; -23.67; 9.39; -3.43; 24.59; 3.22; 59.73; 5.80; 11.21; -0.39; -16.14; -8.55];
% MLS
% D_TCO = [-21.33; 20.23; -29.54; -14.54; -47.41; 12.65; -13.50; 20.06; 7.82; 86.81; 0.92; 19.29; -4.33; -34.97; -2.17];
ICE = [-0.09; -0.06; -0.16; 0.06; -0.01; -0.03; -0.18; -0.12; -0.14; 1.05; -0.17; 0.16; -0.19; 0.05; -0.17];
NAT = [-0.83; 0.50; -1.16; 0.77; 0.56; 0.08; -0.54; 0.60; -1.36; 3.24; -0.60; 0.00; -1.37; 0.93; -0.83];
STS = [-0.47; 0.02; -0.59; 0.08; 0.58; 0.47; -0.45; 0.07; -0.67; 1.27; -0.47; 0.45; -0.68; 0.92; -0.54];

% Calculate the partial correlation coefficient matrix
[r12_34, p12_34] = partialcorr(D_TCO, ICE, [NAT, STS]);
[r13_24, p13_24] = partialcorr(D_TCO, NAT, [ICE, STS]);
[r14_23, p14_23] = partialcorr(D_TCO, STS, [ICE, NAT]);
[r23_14, p23_14] = partialcorr(ICE, NAT, [D_TCO, STS]);
[r24_13, p24_13] = partialcorr(ICE, STS, [D_TCO, NAT]);
[r34_12, p34_12] = partialcorr(NAT, STS, [D_TCO, ICE]);

% Output result
fprintf('Partial correlation coefficient and p-value：\n');
fprintf('r(D_TCO, ICE | NAT, STS) = %.4f, p = %.4f\n', r12_34, p12_34);
fprintf('r(D_TCO, NAT | ICE, STS) = %.4f, p = %.4f\n', r13_24, p13_24);
fprintf('r(D_TCO, STS | ICE, NAT) = %.4f, p = %.4f\n', r14_23, p14_23);
fprintf('r(ICE, NAT | D_TCO, STS) = %.4f, p = %.4f\n', r23_14, p23_14);
fprintf('r(ICE, STS | D_TCO, NAT) = %.4f, p = %.4f\n', r24_13, p24_13);
fprintf('r(NAT, STS | D_TCO, ICE) = %.4f, p = %.4f\n', r34_12, p34_12);