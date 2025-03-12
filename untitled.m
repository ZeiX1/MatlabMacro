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
real_gdp_japan = readtable('real_gdp_japan.csv'); 
real_consumption_japan = readtable('real_hh_final_consumption_japan.csv');
real_investment_japan = readtable('real_gross_fixed_capital_formation_japan.csv');
tfp_japan = readtable('tfp_japan.csv');
cpi_japan = readtable('cpi_japan.csv');
ir_japan = readtable('ir_japan.csv');
employment_japan = readtable('employment_japan.csv');

% Recode Date column
real_gdp_japan.Properties.VariableNames{1} = 'Date';
real_consumption_japan.Properties.VariableNames{1} = 'Date';
real_investment_japan.Properties.VariableNames{1} = 'Date';
tfp_japan.Properties.VariableNames{1} = 'Date';
cpi_japan.Properties.VariableNames{1} = 'Date';
ir_japan.Properties.VariableNames{1} = 'Date';
employment_japan.Properties.VariableNames{1} = 'Date';

% Recode Value column
real_gdp_japan.Properties.VariableNames{2} = 'Value';
real_consumption_japan.Properties.VariableNames{2} = 'Value';
real_investment_japan.Properties.VariableNames{2} = 'Value';
tfp_japan.Properties.VariableNames{2} = 'Value';
cpi_japan.Properties.VariableNames{2} = 'Value';
ir_japan.Properties.VariableNames{2} = 'Value';
employment_japan.Properties.VariableNames{2} = 'Value';

% Convert dates to MATLAB datetime format
real_gdp_japan.Date = datetime(real_gdp_japan.Date, 'InputFormat', 'yyyy-MM-dd');
real_consumption_japan.Date = datetime(real_consumption_japan.Date, 'InputFormat', 'yyyy-MM-dd');
real_investment_japan.Date = datetime(real_investment_japan.Date, 'InputFormat', 'yyyy-MM-dd');
tfp_japan.Date = datetime(tfp_japan.Date, 'InputFormat', 'yyyy-MM-dd');
cpi_japan.Date = datetime(cpi_japan.Date, 'InputFormat', 'yyyy-MM-dd');
ir_japan.Date = datetime(ir_japan.Date, 'InputFormat', 'yyyy-MM-dd');
employment_japan.Date = datetime(employment_japan.Date, 'InputFormat', 'yyyy-MM-dd');

% Transform into time series format
real_gdp_japan = timetable2table(real_gdp_japan);
real_consumption_japan = timetable2table(real_consumption_japan);
real_investment_japan = timetable2table(real_investment_japan);
tfp_japan = timetable2table(tfp_japan);
cpi_japan = timetable2table(cpi_japan);
ir_japan = timetable2table(ir_japan);
employment_japan = timetable2table(employment_japan);

% Interpolate annual TFP into quarterly TFP
tfp_japan = retime(tfp_japan, 'quarterly', 'spline');
% Aggregate monthly employment into quarterly employment
employment_japan = retime(employment_japan, 'quarterly', 'mean');

% Seasonal Adjustments of Time Series
ir_japan.Value = seas(ir_japan.Value, 'seasonality', 'quarterly');
tfp_japan.Value = seas(tfp_japan.Value, 'seasonality', 'quarterly');
cpi_japan.Value = seas(cpi_japan.Value, 'seasonality', 'quarterly');


