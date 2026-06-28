close all; clear; clc;

img = imread("banco/sp.jpg");
if size(img, 3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img;
end

img_binaria = img_gray < 128;
bordas = bwboundaries(img_binaria, 8, 'noholes');

maior_idx = 1;
maior_tamanho = 0;
for k = 1:length(bordas)
    if size(bordas{k}, 1) > maior_tamanho
        maior_tamanho = size(bordas{k}, 1);
        maior_idx = k;
    end
end

PointList = [bordas{maior_idx}(:, 2), bordas{maior_idx}(:, 1)];

result0 = DouglasPecker(PointList, 0);
result1 = DouglasPecker(PointList, 10);
result2 = DouglasPecker(PointList, 50);

figure;

subplot(2, 2, 1);
imshow(img);
title('Imagem Original');

subplot(2, 2, 2);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result0(:, 1), result0(:, 2), 'r-x', 'LineWidth', 2.5, 'MarkerSize', 10);
legend('Contorno Sólido', 'Limiar 0');
title('Divisão Recursiva (Limiar = 0)');
hold off;

subplot(2, 2, 3);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result1(:, 1), result1(:, 2), 'r-x', 'LineWidth', 2.5, 'MarkerSize', 10);
legend('Contorno Sólido', 'Limiar 10');
title('Divisão Recursiva (Limiar = 10)');
hold off;

subplot(2, 2, 4);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result2(:, 1), result2(:, 2), 'r-x', 'LineWidth', 2.5, 'MarkerSize', 10);
legend('Contorno Sólido', 'Limiar 50');
title('Divisão Recursiva (Limiar = 50)');
hold off;
