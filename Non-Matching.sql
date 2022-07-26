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

where Date.PersianDate = '1401/03/18'
	--And Offer.OfferItem_OriginalPK = 546409;
	And Offer.OfferItem_OriginalPK in (
546245
 )
--Order by 26
