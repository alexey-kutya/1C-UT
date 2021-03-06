﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление версии ИБ"
// Серверные процедуры и функции обновления информационной базы
// при смене версии конфигурации.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// См. описание этой же функции в модуле ОбновлениеИнформационнойБазы.
//
// Для использования в других библиотеках и конфигурациях.
//
Функция ВыполнитьОбновлениеИнформационнойБазы(ИсключениеПриНевозможностиБлокировкиИБ = Истина,
	ПриЗапускеКлиентскогоПриложения = Ложь, Перезапустить = Ложь) Экспорт
	
	Возврат ОбновлениеИнформационнойБазыСлужебный.ВыполнитьОбновлениеИнформационнойБазы(
		ИсключениеПриНевозможностиБлокировкиИБ, ПриЗапускеКлиентскогоПриложения, Перезапустить);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Снимает блокировку информационной файловой базы.
Процедура СнятьБлокировкуФайловойБазы() Экспорт
	
	ОбновлениеИнформационнойБазыСлужебный.ПриСнятииБлокировкиФайловойБазы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Записывает в константу продолжительность основного цикла обновления.
//
Процедура ЗаписатьВремяВыполненияОбновления(ВремяНачалаОбновления, ВремяОкончанияОбновления) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	СведенияОбОбновлении = ОбновлениеИнформационнойБазыСлужебный.СведенияОбОбновленииИнформационнойБазы();
	СведенияОбОбновлении.ВремяНачалаОбновления = ВремяНачалаОбновления;
	СведенияОбОбновлении.ВремяОкончанияОбновления = ВремяОкончанияОбновления;
	
	ВремяВСекундах = ВремяОкончанияОбновления - ВремяНачалаОбновления;
	
	Часы = Цел(ВремяВСекундах/3600);
	Минуты = Цел((ВремяВСекундах - Часы * 3600) / 60);
	Секунды = ВремяВСекундах - Часы * 3600 - Минуты * 60;
	
	ПродолжительностьЧасы = ?(Часы = 0, "",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 час'"), Часы));
	ПродолжительностьМинуты = ?(Минуты = 0, "",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 мин'"), Минуты));
	ПродолжительностьСекунды = ?(Секунды = 0, "",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 сек'"), Секунды));
	ПродолжительностьОбновления = ПродолжительностьЧасы + " " + ПродолжительностьМинуты + " " + ПродолжительностьСекунды;
	СведенияОбОбновлении.ПродолжительностьОбновления = СокрЛП(ПродолжительностьОбновления);
	
	ОбновлениеИнформационнойБазыСлужебный.ЗаписатьСведенияОбОбновленииИнформационнойБазы(СведенияОбОбновлении);
	
КонецПроцедуры

#КонецОбласти
