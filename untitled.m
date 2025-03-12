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

Kor_quaterly = readtable('DataCty\KoreaData\quarterly.csv');
Kor_monthly = readtable("DataCty\KoreaData\monthly.csv");
Kor_annual = readtable("DataCty\KoreaData\annual.csv");

% Merge Our datasets
Jap_cpi = readtable("DataCty\japan\cpi_japan.csv");
Jap_emp = readtable("DataCty\japan\employment_japan.csv");
Jap_ir = readtable("DataCty\japan\ir_japan.csv");
Jap_gdp = readtable("DataCty\japan\real_gdp_japan.csv");
Jap_cap = readtable("DataCty\japan\real_gross_fixed_capital_formation_japan.csv");
Jap_con =readtable("DataCty\japan\real_hh_final_consumption_japan.csv");
Jap_tfp = readtable("DataCty\japan\tfp_japan.csv");