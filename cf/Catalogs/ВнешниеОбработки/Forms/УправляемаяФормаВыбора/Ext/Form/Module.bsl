﻿
&НаСервере
Процедура УстановитьОтборПоАвтору()
	
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоАвтору", ПоАвтору);
	УстановитьОтборСписка(Список, ПараметрыОтбора, "ПоАвтору", "Автор");

КонецПроцедуры	

&НаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора, ВидОтбора, ПолеОтбора)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, ПолеОтбора, ПараметрыОтбора[ВидОтбора],,, ПараметрыОтбора[ВидОтбора] <> Неопределено И Не ПараметрыОтбора[ВидОтбора].Пустая());
	    
КонецПроцедуры

&НаКлиенте
Процедура ПоАвторуПриИзменении(Элемент)
	УстановитьОтборПоАвтору();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПоАвтору = Пользователи.ТекущийПользователь();
	УстановитьОтборПоАвтору();
КонецПроцедуры

