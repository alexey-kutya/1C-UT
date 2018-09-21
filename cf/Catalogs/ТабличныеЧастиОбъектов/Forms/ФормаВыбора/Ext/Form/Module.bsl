﻿&НаСервере
Процедура УстановитьОтборПоПараметрам()
	
	ПозицияПодстроки = Найти(Параметры.МетаданныеОбъекта,"Документ.");
	Если ПозицияПодстроки = 1 Тогда
		ИмяОбъекта = Прав(Параметры.МетаданныеОбъекта, СтрДлина(Параметры.МетаданныеОбъекта)-9);
	Иначе
		Сообщить("Неверно задана строка метаданных объекта.");
		ИмяОбъекта = "";
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВидыОбъектов.Ссылка
		|ИЗ
		|	Справочник.ВидыОбъектов КАК ВидыОбъектов
		|ГДЕ
		|	ВидыОбъектов.Конфигурация = &Конфигурация
		|	И ВидыОбъектов.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Конфигурация", Параметры.Конфигурация);
	Запрос.УстановитьПараметр("Наименование", ИмяОбъекта);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Сообщить("Не найден объект метаданных: "+ИмяОбъекта);
		СпрВидОбъекта = Справочники.ВидыОбъектов.ПустаяСсылка();
	Иначе
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		СпрВидОбъекта = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли; 
	
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоВладельцу", СпрВидОбъекта);
	УстановитьОтборСписка(Список, ПараметрыОтбора, "ПоВладельцу", "Владелец");
	
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора, ВидОтбора, ПолеОтбора)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
//		Список, ПолеОтбора, ПараметрыОтбора[ВидОтбора],,, ПараметрыОтбора[ВидОтбора] <> Неопределено И Не ПараметрыОтбора[ВидОтбора].Пустая());
		Список, ПолеОтбора, ПараметрыОтбора[ВидОтбора],,, ПараметрыОтбора[ВидОтбора] <> Неопределено);
	    
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьОтборПоПараметрам();
КонецПроцедуры

