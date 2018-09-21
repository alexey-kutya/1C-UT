﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОсновнойОбъектАдресации = Параметры.ОсновнойОбъектАдресации;
	ОбновитьДанныеЭлементов();
	БизнесПроцессыИЗадачиСервер.ПриОпределенииИспользованияВнешнихЗадачИБизнесПроцессов(ИспользоватьВнешниеЗадачиИБизнесПроцессы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_РолеваяАдресация" Тогда
		ОбновитьДанныеЭлементов();
 	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	НазначитьИсполнителей(Неопределено);
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	НазначитьИсполнителей(Неопределено);
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВсеНазначенияВыполнить(Команда)
	
	ОткрытьФорму("РегистрСведений.ИсполнителиЗадач.ФормаСписка", 
		Новый Структура("Отбор", Новый Структура("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации)),
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВыполнить(Команда)
	ОбновитьДанныеЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура НазначитьИсполнителей(Команда)
	
	Назначение = Элементы.Список.ТекущиеДанные;
	Если Назначение = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Необходимо выбрать роль в списке.'"));
		Возврат;
	КонецЕсли;
	
	Если ИспользоватьВнешниеЗадачиИБизнесПроцессы Тогда
		Если Назначение.ВнешняяРоль = Истина Тогда
			ПоказатьПредупреждение(,НСтр("ru = 'Исполнители внешней роли должны быть определены в другой информационной базе.'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;

	ОткрытьФорму("РегистрСведений.ИсполнителиЗадач.Форма.АдресацияПоОбъектуИРоли", 
		Новый Структура("ОсновнойОбъектАдресации,Роль", 
			ОсновнойОбъектАдресации, 
			Назначение.РольСсылка));
			
КонецПроцедуры

&НаКлиенте
Процедура СписокРолей(Команда)
	ОткрытьФорму("Справочник.РолиИсполнителей.ФормаСписка",,ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСведенияОРоли(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	ПоказатьЗначение(, Элементы.Список.ТекущиеДанные.РольСсылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьДанныеЭлементов()
	
	ВыборкаЗапроса = БизнесПроцессыИЗадачиСервер.ВыбратьРолиСКоличествомИсполнителей(ОсновнойОбъектАдресации);
	СписокОбъект = РеквизитФормыВЗначение("Список");
	СписокОбъект.Очистить();
	Пока ВыборкаЗапроса.Следующий() Цикл
		ТипЗначения = ВыборкаЗапроса.ТипыОсновногоОбъектаАдресации.ТипЗначения;
		ВключаетТип = Истина;
		Если ОсновнойОбъектАдресации <> Неопределено Тогда
			ВключаетТип = ТипЗначения <> Неопределено И ТипЗначения.СодержитТип(ТипЗнч(ОсновнойОбъектАдресации));
		КонецЕсли;
		Если ВключаетТип Тогда
			НоваяСтрока = СписокОбъект.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаЗапроса, "Исполнители,Роль,РольСсылка,ВнешняяРоль"); 
		КонецЕсли;
	КонецЦикла;
	СписокОбъект.Сортировать("Роль");
	Для каждого СтрокаСписка Из СписокОбъект Цикл
		Если СтрокаСписка.Исполнители = 0 Тогда
			СтрокаСписка.ИсполнителиСтрока = ?(СтрокаСписка.ВнешняяРоль, НСтр("ru = 'заданы в другой базе'"), НСтр("ru = 'не заданы'"));
			СтрокаСписка.Картинка = ?(СтрокаСписка.ВнешняяРоль, -1, 1);
		ИначеЕсли СтрокаСписка.Исполнители = 1 Тогда
			СтрокаСписка.ИсполнителиСтрока = Строка(БизнесПроцессыИЗадачиСервер.ВыбратьИсполнителя(ОсновнойОбъектАдресации, СтрокаСписка.РольСсылка));
			СтрокаСписка.Картинка = -1;
		Иначе
			СтрокаСписка.ИсполнителиСтрока =
			  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			  НСтр("ru = '%1 чел'"), Строка(СтрокаСписка.Исполнители) );
			
			СтрокаСписка.Картинка = -1;
		КонецЕсли;
	КонецЦикла;
	ЗначениеВРеквизитФормы(СписокОбъект, "Список");
	
КонецПроцедуры

#КонецОбласти
