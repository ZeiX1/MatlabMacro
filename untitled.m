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
% Inflation rates  
rates = diff(log(cpi_japan.Inflation)) * 400;  % Quarterly annualized % 

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
subplot(3, 3, 1); 
plot(japan.Date, japan.GDP, 'b', 'LineWidth', 1.5);
title('Real GDP');
ylabel('Millions of Domestic Currency');
% Subplot 2: Real Consumption
subplot(3, 3, 2); 
plot(japan.Date, japan.Consumption, 'b', 'LineWidth', 1.5);
title('Real Households Final Consumption');
ylabel('Millions of Domestic Currency');
% Subplot 3: TFP
subplot(3, 3, 3); 
plot(japan.Date, japan.TFP, 'b', 'LineWidth', 1.5);
title('Total Factor Productivity');
ylabel('TFP (Index 2017=1)');
% Subplot 4: Employment
subplot(3, 3, 4); 
plot(japan.Date, japan.Employment, 'b', 'LineWidth', 1.5);
title('Employment');
ylabel('Total People Employed (15+)');
% Subplot 5: Inflation
subplot(3, 3, 5); 
plot(japan.Date, japan.Inflation, 'b', 'LineWidth', 1.5);
ylabel('CPI, All Items (Index 2015=100)');
title('Inflation (CPI)');
% Subplot 6: Real Investment
subplot(3, 3, 6); 
plot(japan.Date, japan.Investment, 'b', 'LineWidth', 1.5);
title('Real Investment');
ylabel('Millions of Domestic Currency');
% Subplot 7: Interest Rates
subplot(3, 3, 7); 
plot(japan.Date, japan.IR, 'b', 'LineWidth', 1.5);
title('Interest Rates');
ylabel('Central Bank Rates (%)');
% Subplot 8: Inflation Rates
subplot(3, 3, 8); 
plot(cpi_japan.Date(2:end), rates, 'b-', 'LineWidth', 1); % Raw data in BLUE
title('Inflation Rates');
ylabel('Inflation Rates (%)');
% Subplot 9: Empty
subplot(3, 3, 9); 
text(0.5, 0.5, 'Additional Metric', 'HorizontalAlignment', 'center');
axis off;
% Legend
for i = 1:8
    subplot(3, 3, i);
    xlabel('Quarter')
end
% Add overall title
sgtitle('Japan Economic Indicators', 'FontSize', 16, 'FontWeight', 'bold');
% Adjust spacing between subplots
set(gcf, 'Position', get(gcf, 'Position').*[1 1 1.2 1.2]);

% HP Filter
[trend_gdp_japan , cycle_gdp_japan] = hpfilter(log(real_gdp_japan.GDP), 1600);
[trend_consumption_japan , cycle_consumption_japan] = hpfilter(log(real_consumption_japan.Consumption), 1600);
[trend_investment_japan , cycle_investment_japan] = hpfilter(log(real_investment_japan.Investment), 1600);
[trend_employment_japan , cycle_employment_japan] = hpfilter(log(employment_japan.Employment), 1600);
[trend_tfp_japan , cycle_tfp_japan] = hpfilter(tfp_japan.TFP, 1600);
[trend_cpi_japan , cycle_cpi_japan] = hpfilter(cpi_japan.Inflation, 1600);
[trend_ir_japan , cycle_ir_japan] = hpfilter(ir_japan.IR, 1600);
[trend_rates_japan , cycle_rates_japan] = hpfilter(rates, 1600);

% Plotting the trend component
figure;
% Subplot 1: Real GDP
subplot(3, 3, 1); 
plot(real_gdp_japan.Date, log(real_gdp_japan.GDP), 'b-', 'LineWidth', 1); % Raw data in BLUE
hold on;
plot(real_gdp_japan.Date, trend_gdp_japan, 'r--', 'LineWidth', 1);  % Cycle in red dashed
hold off;
title('Real GDP (in log)');
% Subplot 2: Real Consumption
subplot(3, 3, 2);  
plot(real_consumption_japan.Date, log(real_consumption_japan.Consumption), 'b-', 'LineWidth', 1); % Raw data in BLUE
hold on;
plot(real_consumption_japan.Date, trend_consumption_japan, 'r--', 'LineWidth', 1);  % Cycle in red dashed
hold off;
title('Real Consumption (in log)');
% Subplot 3: TFP
subplot(3, 3, 3); 
plot(tfp_japan.Date, tfp_japan.TFP, 'b-', 'LineWidth', 1); % Raw data in BLUE
hold on;
plot(tfp_japan.Date, trend_tfp_japan, 'r--', 'LineWidth', 1);  % Cycle in red dashed
hold off;
title('Total Factor Productivity');
% Subplot 4: Employment
subplot(3, 3, 4); 
plot(employment_japan.Date, log(employment_japan.Employment), 'b-', 'LineWidth', 1); % Raw data in BLUE
hold on;
plot(employment_japan.Date, trend_employment_japan, 'r--', 'LineWidth', 1);  % Cycle in red dashed
hold off;
title('Employment (in log)');
% Subplot 5: Inflation
subplot(3, 3, 5); 
plot(cpi_japan.Date, cpi_japan.Inflation, 'b-', 'LineWidth', 1); % Raw data in BLUE
hold on;
plot(cpi_japan.Date, trend_cpi_japan, 'r--', 'LineWidth', 1);  % Cycle in red dashed
hold off;
title('Inflation (CPI)');
% Subplot 6: Real Investment
subplot(3, 3, 6); 
plot(real_investment_japan.Date, log(real_investment_japan.Investment), 'b-', 'LineWidth', 1); % Raw data in BLUE
hold on;
plot(real_investment_japan.Date, trend_investment_japan, 'r--', 'LineWidth', 1);  % Cycle in red dashed
hold off;
title('Real Investment (in log)');
% Subplot 7: Interest Rates
subplot(3, 3, 7); 
plot(ir_japan.Date, ir_japan.IR, 'b-', 'LineWidth', 1); % Raw data in BLUE
hold on;
plot(ir_japan.Date, trend_ir_japan, 'r--', 'LineWidth', 1);  % Cycle in red dashed
hold off;
title('Interest Rates');
% Subplot 8: Inflation Rates
subplot(3, 3, 8); 
plot(cpi_japan.Date(2:end), rates, 'b-', 'LineWidth', 1); % Raw data in BLUE
hold on;
plot(cpi_japan.Date(2:end), trend_rates_japan, 'r--', 'LineWidth', 1);  % Cycle in red dashed
hold off;
title('Inflation Rates');
% Subplot 9: Empty
subplot(3, 3, 9); 
text(0.5, 0.5, 'Additional Metric', 'HorizontalAlignment', 'center');
axis off;
% Overall Title
sgtitle('Japan HP filter: Trend Component', 'FontSize', 16, 'FontWeight', 'bold');
% Adjust spacing between subplots
set(gcf, 'Position', get(gcf, 'Position').*[1 1 1.2 1.2]);
for i = 1:8
    subplot(3, 3, i);
    xlabel('Quarter')
    legend('Data', 'Trend',  'Location', 'best');
end

% Plotting the cyclical component
figure;
% Subplot 1: Real GDP Cycle
subplot(3, 3, 1); 
plot(real_gdp_japan.Date, cycle_gdp_japan, 'r-', 'LineWidth', 1);
title('Real GDP (in log)');
grid on;
% Subplot 2: Real Consumption Cycle
subplot(3, 3, 2);  
plot(real_consumption_japan.Date, cycle_consumption_japan, 'r-', 'LineWidth', 1);
title('Real Consumption (in log)');
grid on;
% Subplot 3: TFP Cycle
subplot(3, 3, 3); 
plot(tfp_japan.Date, cycle_tfp_japan, 'r-', 'LineWidth', 1);
title('Total Factor Productivity');
grid on;
% Subplot 4: Employment Cycle
subplot(3, 3, 4); 
plot(employment_japan.Date, cycle_employment_japan, 'r-', 'LineWidth', 1);
title('Employment (in log)');
grid on;
% Subplot 5: Inflation Cycle
subplot(3, 3, 5); 
plot(cpi_japan.Date, cycle_cpi_japan, 'r-', 'LineWidth', 1);
title('Inflation (CPI)');
grid on;
% Subplot 6: Real Investment Cycle
subplot(3, 3, 6); 
plot(real_investment_japan.Date, cycle_investment_japan, 'r-', 'LineWidth', 1);
title('Real Investment (in log)');
grid on;
% Subplot 7: Interest Rates Cycle
subplot(3, 3, 7); 
plot(ir_japan.Date, cycle_ir_japan, 'r-', 'LineWidth', 1);
title('Interest Rates');
xlabel('Year');
grid on;
% Subplot 8: Inflation Rates Cycle
subplot(3, 3, 8); 
plot(cpi_japan.Date(2:end), cycle_rates_japan, 'r-', 'LineWidth', 1);
hold on;
hold off;
title('Inflation Rates');
xlabel('Year');
grid on;
% Subplot 9: Empty
subplot(3, 3, 9); 
text(0.5, 0.5, 'Additional Metric', 'HorizontalAlignment', 'center');
axis off;
% Add zero reference lines to all subplots
for i = 1:8
    subplot(3, 3, i);
    h = yline(0, 'k--', 'LineWidth', 0.5);
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    hLegend = legend('Cyclical Component', 'Location', 'best');
    hLegend.ItemTokenSize = [10,10]; % Makes the line sample smaller
    hLegend.FontSize = 8;
    xlabel('Quarter')
end
% Overall title
sgtitle('Japan HP filter: Cyclical Component ', 'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
% Adjust spacing between subplots
set(gcf, 'Position', get(gcf, 'Position').*[1 1 1.2 1.2]);