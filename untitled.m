% Charge csv files as tables
% NCPHIRSAXDCKRQ    Real Households Final Consumption Expenditure for Republic of Korea,   
%                   Millions of Domestic Currency, Quarterly, Seasonally Adjusted
%                   Data Updated: 2024-02-12
%
% NGDPRSAXDCKRQ     Real Gross Domestic Product for Republic of Korea, 
%                   Millions of Domestic Currency, Quarterly, Seasonally Adjusted
%                   Data Updated: 2025-02-10
%
% NFIRNSAXDCKRQ     Real Gross Fixed Capital Formation for Republic of Korea, 
%                   Millions of Domestic Currency, Quarterly, Not Seasonally Adjusted
%                   Data Updated: 2025-02-10
%
% RTFPNAKRA632NRUG  Total Factor Productivity at Constant National Prices for Republic of  
%                   Korea, Index 2017=1, Annual, Not Seasonally Adjusted
%                   Data Updated: 2023-02-27
%
% KORCPIALLMINMEI   Consumer Price Indices (CPIs, HICPs), COICOP 1999: Consumer Price      
%                   Index: Total for Korea, Index 2015=100, Monthly, Not Seasonally Adjusted
%                   Data Updated: 2023-12-12
%
% IRSTCI01KRM156N   Interest Rates: Immediate Rates (< 24 Hours): Call Money/Interbank     
%                   Rate: Total for Korea, Percent, Monthly, Not Seasonally Adjusted
%                   Data Updated: 2025-02-17

 % Data loading for Korea
Kor_quaterly = readtable('DataCty\KoreaData\quarterly.csv');
Kor_monthly = readtable("DataCty\KoreaData\monthly.csv");
Kor_annual = readtable("DataCty\KoreaData\annual.csv");

 % Data loading for Japan
real_gdp_japan = readtable('DataCty\japan\real_gdp_japan.csv'); 
real_consumption_japan = readtable('DataCty\japan\real_hh_final_consumption_japan.csv');
real_investment_japan = readtable('DataCty\japan\real_gross_fixed_capital_formation_japan.csv');
tfp_japan = readtable('DataCty\japan\tfp_japan.csv');
cpi_japan = readtable('DataCty\japan\cpi_japan.csv');
ir_japan = readtable('DataCty\japan\ir_japan.csv');
employment_japan = readtable('DataCty\japan\employment_japan.csv');

% Recode Date column
real_gdp_japan.Properties.VariableNames{1} = 'Date';
real_consumption_japan.Properties.VariableNames{1} = 'Date';
real_investment_japan.Properties.VariableNames{1} = 'Date';
tfp_japan.Properties.VariableNames{1} = 'Date';
cpi_japan.Properties.VariableNames{1} = 'Date';
ir_japan.Properties.VariableNames{1} = 'Date';
employment_japan.Properties.VariableNames{1} = 'Date';

% Recode Value column
real_gdp_japan.Properties.VariableNames{2} = 'GDP';
real_consumption_japan.Properties.VariableNames{2} = 'Consumption';
real_investment_japan.Properties.VariableNames{2} = 'Investment';
tfp_japan.Properties.VariableNames{2} = 'TFP';
cpi_japan.Properties.VariableNames{2} = 'Inflation';
ir_japan.Properties.VariableNames{2} = 'IR';
employment_japan.Properties.VariableNames{2} = 'Employment';

% Convert dates to MATLAB datetime format
real_gdp_japan.Date = datetime(real_gdp_japan.Date, 'InputFormat', 'yyyy-MM-dd');
real_consumption_japan.Date = datetime(real_consumption_japan.Date, 'InputFormat', 'yyyy-MM-dd');
real_investment_japan.Date = datetime(real_investment_japan.Date, 'InputFormat', 'yyyy-MM-dd');
tfp_japan.Date = datetime(tfp_japan.Date, 'InputFormat', 'yyyy-MM-dd');
cpi_japan.Date = datetime(cpi_japan.Date, 'InputFormat', 'yyyy-MM-dd');
ir_japan.Date = datetime(ir_japan.Date, 'InputFormat', 'yyyy-MM-dd');
employment_japan.Date = datetime(employment_japan.Date, 'InputFormat', 'yyyy-MM-dd');

% Transform into time series format
real_gdp_japan = table2timetable(real_gdp_japan, 'RowTimes', 'Date');
real_consumption_japan = table2timetable(real_consumption_japan, 'RowTimes', 'Date');
real_investment_japan = table2timetable(real_investment_japan, 'RowTimes', 'Date');
tfp_japan = table2timetable(tfp_japan, 'RowTimes', 'Date');
cpi_japan = table2timetable(cpi_japan, 'RowTimes', 'Date');
ir_japan = table2timetable(ir_japan, 'RowTimes', 'Date');
employment_japan = table2timetable(employment_japan, 'RowTimes', 'Date');

% Interpolate annual TFP into quarterly TFP
tfp_japan = retime(tfp_japan, 'quarterly', 'spline');
% Aggregate monthly employment into quarterly employment
employment_japan = retime(employment_japan, 'quarterly', 'mean');

% Merged dataset
japan = synchronize(...
    real_gdp_japan, ...
    real_consumption_japan, ...
    real_investment_japan, ...
    tfp_japan, ...
    cpi_japan, ...
    ir_japan, ...
    employment_japan, ...
    'union' ...
);

% Plotting the time series
figure;
% Subplot 1: Real GDP
subplot(2, 2, 1); 
plot(japan.Date, japan.GDP, 'LineWidth', 1.5);
title('Real GDP of Japan');
xlabel('Date');
ylabel('Millions of Domestic Currency');
grid on;
% Subplot 2: Real Consumption
subplot(2, 2, 2); 
plot(japan.Date, japan.Consumption, 'LineWidth', 1.5);
title('Real Households Final Consumption Expenditure of Japan');
xlabel('Date');
ylabel('Millions of Domestic Currency');
grid on;
% Subplot 3: TFP
subplot(2, 2, 3); 
plot(japan.Date, japan.TFP, 'LineWidth', 1.5);
title('Total Factor Productivity of Japan');
xlabel('Date');
ylabel('TFP (Index 2017=1)');
grid on;
% Subplot 4: Employment
subplot(2, 2, 4); 
plot(japan.Date, japan.Employment, 'LineWidth', 1.5);
title('Employment of Japan');
xlabel('Date');
ylabel('Persons (15 Years or over)');
grid on;

% Subplot 5: Inflation
figure;
subplot(2, 2, 1); 
plot(japan.Date, japan.Inflation, 'LineWidth', 1.5);
title('Inflation of Japan');
xlabel('Date');
ylabel('CPI, All Items (Index 2015=100)');
grid on;
% Subplot 6: Interest Rates
subplot(2, 2, 2); 
plot(japan.Date, japan.IR, 'LineWidth', 1.5);
title('Interest Rates of Japan');
xlabel('Date');
ylabel('Central Bank Immediate Rates (%)');
grid on;
% Subplot 4: Real Invesment
subplot(2, 2, 3); 
plot(japan.Date, japan.Employment, 'LineWidth', 1.5);
title('Real Gross Capital Formation of Japan');
xlabel('Date');
ylabel('Millions of Domestic Currency');
grid on;
