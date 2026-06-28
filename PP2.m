close all, clear, clc;

img = imread("banco/sp.jpg");
if size(img, 3) == 3
    img = rgb2gray(img);
end

img_binaria = img < 128;
contornos_afinados = bwmorph(img_binaria, 'thin', Inf);

bordas = bwboundaries(contornos_afinados, 4);
PointList = [bordas{1}(:, 2), bordas{1}(:, 1)];

limiar = 5;

[~, idx_esq] = min(PointList(:, 1));
[~, idx_dir] = max(PointList(:, 1));
idx1 = min(idx_esq, idx_dir);
idx2 = max(idx_esq, idx_dir);

p1 = PointList(idx1:idx2, :);
p2 = [PointList(idx2:end, :); PointList(1:idx1, :)];

res1 = DouglasPecker(p1, limiar);
res2 = DouglasPecker(p2, limiar);

result = [res1(1:end-1, :); res2];

figure;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1); hold on;
plot(result(:, 1), result(:, 2), 'r-x', 'LineWidth', 2);
axis equal;
set(gca, 'YDir', 'reverse');
legend('Original', 'RDP Simplificado');
2
