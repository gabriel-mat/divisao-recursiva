close all; clear; clc;

img = imread("banco/macaco.png");
if size(img, 3) == 3 % se tiver 3 canais rgb,
    img_gray = rgb2gray(img); % transforma em tons de cinza
else
    img_gray = img;
end

img_binaria = img_gray < 128; % binarizacao

% extracao dos contornos
% (transformacao da fronteira em uma sequencia de coordenadas)
% - conectividade 8
% - retorna um array com as sequencias de pixels na borda de cada objeto
% - noholes ignora o contorno interno
bordas = bwboundaries(img_binaria, 8, 'noholes'); 

% seleciona o maior objeto, ou seja, o principal
maior_idx = 1;
maior_tamanho = 0;
for k = 1:length(bordas)
    if size(bordas{k}, 1) > maior_tamanho
        maior_tamanho = size(bordas{k}, 1);
        maior_idx = k;
    end
end

PointList = [bordas{maior_idx}(:, 2), bordas{maior_idx}(:, 1)];

result0 = DouglasPeucker(PointList, 0);
result1 = DouglasPeucker(PointList, 10);
result2 = DouglasPeucker(PointList, 50);
% o limiar 50 preserva apenas os vertices mais significativos, gerando um poligono bem mais simples

figure;

subplot(2, 2, 1);
imshow(img);
title('Imagem Original');

subplot(2, 2, 2);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result0(:, 1), result0(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 2);
legend('Contorno Solido', 'Limiar 0');
title('Divisao Recursiva (Limiar = 0)');
hold off;

subplot(2, 2, 3);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result1(:, 1), result1(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 4);
legend('Contorno Solido', 'Limiar 10');
title('Divisao Recursiva (Limiar = 10)');
hold off;

subplot(2, 2, 4);
imshow(img);
hold on;
plot(PointList(:, 1), PointList(:, 2), 'b-', 'LineWidth', 1.5);
plot(result2(:, 1), result2(:, 2), 'r-x', 'LineWidth', 1, 'MarkerSize', 4);
legend('Contorno Solido', 'Limiar 50');
title('Divisao Recursiva (Limiar = 50)');
hold off;


figure;

subplot(1,3,1);
numVertices = size(result0,1);
plot(result0(:, 1), result0(:, 2), 'r-o', 'LineWidth', 1, 'MarkerSize', 2);
axis equal;
set(gca,'YDir','reverse');
grid on;
title(sprintf('Limiar = 0\n%d vertices', numVertices));

subplot(1,3,2);
numVertices = size(result1,1);
plot(result1(:, 1), result1(:, 2), 'r-o', 'LineWidth', 1, 'MarkerSize', 4);
axis equal;
set(gca,'YDir','reverse');
grid on;
title(sprintf('Limiar = 10\n%d vertices', numVertices));

subplot(1,3,3);
numVertices = size(result2,1);
plot(result2(:, 1), result2(:, 2), 'r-o', 'LineWidth', 1, 'MarkerSize', 4);
axis equal;
set(gca,'YDir','reverse');
grid on;
title(sprintf('Limiar = 50\n%d vertices', numVertices));
