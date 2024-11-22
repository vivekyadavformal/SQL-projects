-- 1: Find total value of Assets in Each Portfolio
select p.portfolioid, sum(t.quantity * mp.marketprice) as totalportfoliovalue
from transactions t
join marketprices mp on t.assetid = mp.assetid
join portfolios p on t.portfolioid = p.portfolioid
where t.transactiontype = 'Buy'
group by p.portfolioid;


-- 2: Total Quantity of Each Asset Held by an Investor
select i.investorid, a.assetname, sum(t.quantity) as totalquantity
from transactions t
join assets a on t.assetid = a.assetid
join portfolios p on t.portfolioid = p.portfolioid
join investors i on p.investorid = i.investorid
group by i.investorid, a.assetname;

-- 3: Total Profit/Loss per Asset

select a.assetname,
    sum(case when t.transactiontype = 'Buy' then t.quantity * mp.marketprice * -1
             when t.transactiontype = 'Sell' then t.quantity * mp.marketprice end) as totalprofitloss
from transactions t
join assets a on t.assetid = a.assetid
join marketprices mp on t.assetid = mp.assetid
group by a.assetname;

-- 4: Number of Transactions per Investor

select i.investorid, i.name, count(t.transactionid) as totaltransactions
from transactions t
join portfolios p on t.portfolioid = p.portfolioid
join investors i on p.investorid = i.investorid
group by i.investorid, i.name;

-- 5: Asset Holdings of an Investor

select i.investorid, i.name, a.assetname, sum(t.quantity) as totalquantity
from transactions t
join assets a on t.assetid = a.assetid
join portfolios p on t.portfolioid = p.portfolioid
join investors i on p.investorid = i.investorid
where i.investorid = 1 -- replace with investor id for specific investor
group by i.investorid, i.name, a.assetname;

-- 6: Asset Price Trends Over Time

SELECT a.assetname, mp.PriceDate, mp.MarketPrice
FROM marketprices mp
JOIN assets a ON mp.AssetID = a.AssetID
ORDER BY a.assetname, mp.PriceDate
LIMIT 1000;

-- 7: Portfolio Performance by Asset Type

select p.portfolioid, a.assettype, sum(t.quantity * mp.marketprice) as portfolioassetvalue
from transactions t
join marketprices mp on t.assetid = mp.assetid
join assets a on t.assetid = a.assetid
join portfolios p on t.portfolioid = p.portfolioid
group by p.portfolioid, a.assettype;

