﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокРассылки = ХранилищеОбщихНастроек.Загрузить("СписокРассылкиРелизы",,,"Робот");
	
КонецПроцедуры


&НаКлиенте
Процедура ПриЗакрытии()
	
	ПриЗакрытииНаСервере(СписокРассылки);
	
КонецПроцедуры


&НаСервереБезКонтекста
Процедура ПриЗакрытииНаСервере(СписокРассылки)
	
	ХранилищеОбщихНастроек.Сохранить("СписокРассылкиРелизы",,СписокРассылки,,"Робот");
	
КонецПроцедуры

