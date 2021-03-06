﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПоСотруднику = Справочники.Сотрудники.НайтиПоРеквизиту("ФизЛицо", Пользователи.ТекущийПользователь().ФизЛицо);
	УстановитьОтбор();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор()
	
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоСотруднику", ПоСотруднику);
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Исполнитель", ПараметрыОтбора["ПоСотруднику"],,, ПараметрыОтбора["ПоСотруднику"] <> Неопределено И Не ПараметрыОтбора["ПоСотруднику"].Пустая());
	
КонецПроцедуры


&НаКлиенте
Процедура ПоСотрудникуПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

