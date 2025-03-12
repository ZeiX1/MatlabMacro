% Charge csv files as tables
J1 = readtable('data1.csv');
J2 = readtable('data2.csv');
J3 = readtable('data1.csv');
J4 = readtable('data2.csv');
J5 = readtable('data1.csv');
J6 = readtable('data2.csv');
J7 = readtable('data1.csv');
J8 = readtable('data2.csv');
J9 = readtable('data1.csv');

K1 = readtable('data1.csv');
K2 = readtable('data2.csv');
K3 = readtable('data1.csv');
K4 = readtable('data2.csv');
K5 = readtable('data1.csv');
K6 = readtable('data2.csv');
K7 = readtable('data1.csv');
K8 = readtable('data2.csv');
K9 = readtable('data1.csv');

% Merge Our datasets
MergedTable = join(T1, T2, 'Keys', 'ID');
