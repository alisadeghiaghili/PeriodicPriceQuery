Select 
	   tarikh as N'تاریخ'
	 , nameTejarieKala As N'نام تجاری کالا'
	 , nameTolidKonande As 'نام تولید کننده'
	 , namaad As N'نماد'
	 , noeQarardad As N'نوع قرارداد'
	 , ArzeBeTon As N'عرضه (تن)'
	 , vahedAsliArze As N'واحد اصلی عرضه'
	 , zaribeTabdil As N'ضریب تبدیل'
	 , vahedeVazn As N'واحد وزن'
	 , qeymatePayeyeArze As N'قیمت پایه عرضه'
	 , qeymateArzeDarTalar As N'قیمت عرضه در تالار'
	 , taqazayeVoroodi As N'تقاضای ورودی - پایان سبز (تن)'
	 , balatarinQeymateTaqaza As N'بالاترین قیمت تقاضا (ریال)'
	 , sum(meqdareMoameleShode) As N'مقدار معامله شده'
	 , kamtarinQeymateMoameleShode As N'کمترین قیمت معامله شده(ریال)'
	 , qeymat As N'قیمت (ريال)'
	 , motevaseteQeymateMoamele As N'متوسط قیمت معامله شده (واحد اصلی)'
	 , bishtarinQeymat As N'بیشترین قیمت (ریال)'
	 , sum(arzesheKol) As N'ارزش کل'
	 , tarikheTahvil As N'تاریخ تحویل'
	 , zirGorooh As N'زیرگروه کالا'
	 , gorooh As N'گروه کالا'
	 , gorooheAsli As N'گروه اصلی کالا'
	 , arzeKonandeh As N'عرضه کننده'
	 , ravesheArzeh As N'روش عرضه'
	 , codeArzeh As N'کد عرضه'
	 , noeArzeh As 'نوع عرضه'
	 , nahveyeArzeh As 'نحوه عرضه'
	 , shiveyeKharid As N'شیوه خرید'
	 , tarikheQarardad As N'تاریخ قرارداد'
from (
	   Select 
	   Date.PersianDate As tarikh
	 , Symbol.Commodity_PersianName AS nameTejarieKala
	 , Symbol.Producer_PersianName As nameTolidKonande
	 , Symbol.TradingSymbol As namaad
	 , ContractKind.PersianName As noeQarardad
	 , 0 As arzeBeTon
	 , 0 As vahedAsliArze
	 , Symbol.CommodityUnitMeasure_Coefficient As zaribeTabdil
	 , Symbol.CommodityUnitMeasure_PersianName As vahedeVazn
	 , 0 As qeymatePayeyeArze
	 , Max(Contract.HallMatchingPrice) As qeymateArzeDarTalar
	 , Offer.HallGreenRequestQuantity As taqazayeVoroodi
	 , Offer.HallPurchaseMaxPrice As balatarinQeymateTaqaza
	 , Sum(Contract.HallMatchingQuantity) As meqdareMoameleShode
	 , Offer.HallContractMinPrice As kamtarinQeymateMoameleShode
	 , Max(Contract.HallMatchingPrice) As qeymat
	 , 0 As motevaseteQeymateMoamele
	 , Offer.HallContractMaxPrice As bishtarinQeymat
	 , Sum(Contract.TotalPrice) / 1000 As arzesheKol
	 , DeliveryDate.PersianDate As tarikheTahvil
	 , Symbol.[CommoditySubGroup_PersianName] AS zirGorooh
	 , Symbol.[CommodityGroup_PersianName] AS gorooh
	 , Symbol.CommodityMainGroup_PersianName As gorooheAsli
	 , Supplier.Customer_Name As arzeKonandeh
	 , '' As ravesheArzeh
	 , Offer.OfferItem_OriginalPK As codeArzeh
	 , OfferKind.Name As noeArzeh
	 , SupplyMode.bSupplyModeDesc As nahveyeArzeh
	 , BuyMethod.PersianName As shiveyeKharid
	 , ContractDate.PersianDate As tarikheQarardad

From Auction_DM.Auction_Fact.Contract
Inner Join Auction_DM.Auction_Fact.Offer
	On Contract.Offer_ID = Offer.ID
Inner Join Auction_DM.Auction_Dim.Symbol
	On Offer.Symbol_ID = Symbol.ID
Inner Join Auction_DM.General_Dim.Date
	On Offer.HallDate_ID = Date.ID
Inner Join Auction_DM.Auction_Dim.ContractKind
	On Contract.ContractKind_ID = ContractKind.ID
LEFT Join Auction_DM.Auction_Fact.CustomerContract
	On Contract.ID = CustomerContract.Contract_ID
LEFT Join Auction_DM.General_Dim.Date As DeliveryDate
	On DeliveryDate.ID = CustomerContract.HallMatchingDeliveryDate_ID
Inner Join Auction_DM.Auction_Dim.Supplier
	On Offer.Supplier_ID = Supplier.ID
Inner Join Auction_DM.Auction_Dim.OfferKind
	On Offer.OfferKind_ID = OfferKind.ID
Inner Join Auction_DM.Auction_Dim.BuyMethod
	On Offer.BuyMethod_ID = BuyMethod.ID
Inner Join [Auction].[dbo].[tbSupplyMode] As SupplyMode
	On Offer.SupplyMode_ID = SupplyMode.bSupplyModePK
Inner Join Auction_DM.General_Dim.Date As ContractDate
	On Contract.HallMatchingDate_ID = ContractDate.ID

where Contract.IsExcess = 1
	--And Contract.OfferItem_OriginalPK = 546517
	And Contract.HallMatchingDate_ID Between (select ID from Auction_DM.General_Dim.Date where PersianDate = '1401/03/18') And (select ID from Auction_DM.General_Dim.Date where PersianDate = '1401/03/18')
	--And Date.PersianDate = '1401/03/18'

group by
	    Contract.Offer_ID
	   , Symbol.CommodityMainGroup_PersianName 
	   , Date.PersianDate
	   , Symbol.Commodity_PersianName 
	   , Symbol.Producer_PersianName 
	   , Symbol.TradingSymbol
	   , ContractKind.PersianName
	   , Symbol.CommodityUnitMeasure_Coefficient
	   , Symbol.CommodityUnitMeasure_PersianName 
	   , Offer.HallGreenRequestQuantity
	   , Offer.HallPurchaseMaxPrice
	   , Offer.HallContractMinPrice 
	   , Offer.HallContractMaxPrice
	   , DeliveryDate.PersianDate
	   , Symbol.[CommoditySubGroup_PersianName]
	   , Symbol.[CommodityGroup_PersianName] 
	   , Supplier.Customer_Name 
	   , Offer.OfferItem_OriginalPK 
	   , OfferKind.Name
	   , SupplyMode.bSupplyModeDesc 
	   , BuyMethod.PersianName
	   , CustomerContract.Quantity
	   , ContractDate.PersianDate
	   ) As Matching

group by 
	   tarikh 
	 , nameTejarieKala
	 , nameTolidKonande
	 , namaad 
	 , noeQarardad 
	 , ArzeBeTon 
	 , vahedAsliArze 
	 , zaribeTabdil 
	 , vahedeVazn 
	 , qeymatePayeyeArze 
	 , qeymateArzeDarTalar 
	 , taqazayeVoroodi 
	 , balatarinQeymateTaqaza 
	 , kamtarinQeymateMoameleShode 
	 , qeymat 
	 , motevaseteQeymateMoamele 
	 , bishtarinQeymat 
	 , tarikheTahvil 
	 , zirGorooh 
	 , gorooh 
	 , gorooheAsli 
	 , arzeKonandeh
	 , ravesheArzeh
	 , codeArzeh 
	 , noeArzeh 
	 , nahveyeArzeh 
	 , shiveyeKharid
	 , tarikheQarardad 

union

Use Auction_DM;
Go

Select Distinct
	   Date.PersianDate As N'تاریخ'
	  , Symbol.Commodity_PersianName AS N'نام تجاری کالا'
	  , symbol.Producer_PersianName As N'نام تولید کننده'
	  , Symbol.TradingSymbol As N'نماد'
	  , ContractKind.PersianName As N'نوع قرارداد'
	  , Offer.HallSaleQuantity/1000 As N'عرضه (تن)'
	  , Offer.HallSaleQuantity As N'واحد اصلی عرضه'
	  , Symbol.CommodityUnitMeasure_Coefficient As N'ضریب تبدیل'
	  , Symbol.CommodityUnitMeasure_PersianName As N'واحد وزن'
	  , Offer.OfferPrice / Symbol.CommodityUnitMeasure_Coefficient As N'قیمت پایه عرضه'
	  , Offer.OfferPrice / Symbol.CommodityUnitMeasure_Coefficient As N'قیمت عرضه در تالار' 
	  , Offer.HallPurchaseQuantity/1000 As N'تقاضای پایانی (تن)'
	  , Offer.HallGreenRequestQuantity N'تقاضای ورودی - پایان سبز (تن)'
	  , Offer.HallRequestMaxPrice As N'بالاترین قیمت تقاضا (ریال)'
	  , Offer.HallContractTotalQuantity/1000 As N'مقدار معامله شده'
	  , Offer.HallContractMinPrice As N'کمترین قیمت معامله شده(ریال)'
	  , Round(Offer.HallContractAVGPrice, 0) As N'قیمت (ريال)'
	  , Case 
			When Currency.Currency_OriginalPK <> 1
			THEN (Offer.HallPurchaseMinPrice + Offer.HallPurchaseMaxPrice)/2 
			ELSE 0
		END
		As N'متوسط قیمت معامله شده (واحد اصلی)'
	  , Offer.HallContractMaxPrice As N'بیشترین قیمت (ریال)'
	  , Offer.HallContractTotalPrice/1000 As N'ارزش کل'
	  , DeliveryDate.PersianDate As N'تاریخ تحویل'
	  , Symbol.[CommoditySubGroup_PersianName] AS N'نام زیرگروه'
	  , Symbol.[CommodityGroup_PersianName] AS N'گروه کالا'
	  , Symbol.CommodityMainGroup_PersianName As N'گروه اصلی کالا'
	  , '---' As 'جزییات سبد'
	  , Supplier.Customer_Name As N'عرضه کننده'
	  , N'عادی' As N'روش عرضه'
	  , Offer.OfferItem_OriginalPK As N'کد عرضه'
	  , OfferKind.Name As 'نوع عرضه'
	  , SupplyMode.bSupplyModeDesc As 'نحوه عرضه'
	  , BuyMethod.PersianName As N'شیوه خرید'

From Auction_DM.Auction_Dim.Symbol
Inner Join Auction_DM.Auction_Fact.Offer
	On Symbol.ID = Offer.Symbol_ID
Inner Join Auction_DM.Auction_Dim.Supplier
	On Offer.Supplier_ID = Supplier.ID
Inner Join Auction_DM.General_Dim.Date
	On Offer.HallDate_ID = Date.ID
Inner Join Auction_DM.Auction_Dim.ContractKind
	On Offer.ContractKind_ID = ContractKind.ID
LEFT Join Auction_DM.Auction_Fact.Contract
	On Contract.Offer_ID = offer.ID
LEFT Join Auction_DM.Auction_Fact.CustomerContract
	On Contract.ID = CustomerContract.Contract_ID
LEFT Join Auction_DM.General_Dim.Date As DeliveryDate
	On DeliveryDate.ID = offer.DeliveryDate_ID
Inner Join Auction_DM.Auction_Dim.OfferKind
	On Offer.OfferKind_ID = OfferKind.ID
Inner Join Auction_DM.Auction_Dim.BuyMethod
	On Offer.BuyMethod_ID = BuyMethod.ID
Inner Join [Auction].[dbo].[tbSupplyMode] As SupplyMode
	On Offer.SupplyMode_ID = SupplyMode.bSupplyModePK
Inner Join Auction_DM.Auction_Dim.Currency
	On Offer.Currency_ID = Currency.ID

where Date.ID Between (select ID from Auction_DM.General_Dim.Date where PersianDate = '1401/03/18') And (select ID from Auction_DM.General_Dim.Date where PersianDate = '1401/03/18')
	--And Offer.OfferItem_OriginalPK = 546409;
--Order by 26
