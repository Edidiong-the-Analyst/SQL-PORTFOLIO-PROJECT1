Select*
From ProjectPortfolio..[SalesShippingData]

ALTER TABLE ProjectPortfolio..[SalesShippingData]
DROP COLUMN F12, F13

-------------------------------------------------------------------------------------------------------------------

--Convert Date (From timestamp to Date only)

ALTER TABLE ProjectPortfolio..[SalesShippingData]
ADD MonthConverted Date

Update SalesShippingData
SET Month = CONVERT(Date, Month)

Update SalesShippingData
SET MonthConverted = CONVERT(Date, Month)

Select*
From ProjectPortfolio..[SalesShippingData]

-------------------------------------------------------------------------------------------------------------------------------------------
--Sales by Category according to Chain

Select Distinct(Category), (Select Distinct(Chain)) Chain, Round(Sum(Sales),0) SumofSales
From ProjectPortfolio..[SalesShippingData]
Group by Category, Chain
Order by 1 desc

-- Total Sales by Category alone
Select  Distinct(Category), Round(Sum(Sales),0) SumofSales
From ProjectPortfolio..[SalesShippingData]
Group by Category
Order by 2 desc

-------------------------------------------------------------------------------------------------------------------------------------------
--Sales by Chain
		-- with Month/Year
Select Distinct(Chain) Chain, MonthConverted, Round(Sum(Sales),0) SumofSales
From ProjectPortfolio..[SalesShippingData]
Group by MonthConverted, Chain

		--General
Select Distinct(Chain) Chain, Round(Sum(Sales),0) SumofSales
From ProjectPortfolio..[SalesShippingData]
Group by Chain

-------------------------------------------------------------------------------------------------------------------------------------------
--Sales by Manager

Select Distinct(Manager) Manager, Round(Sum(Sales),0) SumofSales
From ProjectPortfolio..[SalesShippingData]
Group by Manager
Order by 2 desc

			--with Chains and State
Select Distinct(Manager), (Select Distinct(Chain)) Chain, (Select Distinct(State)) State, Round(Sum(Sales),0) SumofSales
From ProjectPortfolio..[SalesShippingData]
Group by Manager, Chain, State
Order by 3 desc

------------------------------------------------------------------------------------------------------------------------------------------

--TOTAL SALES FOR EACH STATE

Select Distinct(State) State, Round(Sum(Sales),0) SumofSales
From ProjectPortfolio..[SalesShippingData]
Group by State
Order by 2 

--SALES TREND BY STATE AT CHAIN AND MONTH

Select Distinct(Chain) Chain, (Select Distinct(State)) State, MonthConverted, Round(Sum(Sales),0) SumofSales
From ProjectPortfolio..[SalesShippingData]
Group by Chain, State,  MonthConverted


--TOTAL SALES FOR EACH STATE AND COUNTRY
Select Distinct(State) State, Country, Round(Sum(Sales),0) SumofSales
From ProjectPortfolio..[SalesShippingData]
Group by State, Country
Order by 2 