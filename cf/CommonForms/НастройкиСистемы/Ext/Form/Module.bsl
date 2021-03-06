﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаголовокИзменен = Ложь;
	МаксимальныйРазмерФайла = ФайловыеФункции.МаксимальныйРазмерФайлаОбщий() / (1024*1024);
	
	Шрифт = Константы.ШрифтФорматированногоТекста.Получить().Получить();
	Если Шрифт = Неопределено Тогда
		Шрифт = РаботаСФорматированнымДокументом.ШрифтПоУмолчанию();
	КонецЕсли; 
	ШрифтФорматированногоТекста = Шрифт;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьИзменениеКонстант(ТекущийОбъект);
	
	Константы.ШрифтФорматированногоТекста.Установить(Новый ХранилищеЗначения(ШрифтФорматированногоТекста));
	
	Если НЕ ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Если ИзмененныеКонстанты.Свойство("ИспользоватьПолнотекстовыйПоиск") Тогда
			
			Если НаборКонстант.ИспользоватьПолнотекстовыйПоиск Тогда
				
				ПолнотекстовыйПоиск.УстановитьРежимПолнотекстовогоПоиска(
					РежимПолнотекстовогоПоиска.Разрешить);
			Иначе
				ПолнотекстовыйПоиск.УстановитьРежимПолнотекстовогоПоиска(
					РежимПолнотекстовогоПоиска.Запретить);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МаксимальныйРазмерФайлаБайт = МаксимальныйРазмерФайла * (1024*1024);
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Константы.МаксимальныйРазмерФайлаОбластиДанных.Установить(МаксимальныйРазмерФайлаБайт);
	Иначе
		Константы.МаксимальныйРазмерФайла.Установить(МаксимальныйРазмерФайлаБайт);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не НаборКонстант.ХранитьФайлыВТомахНаДиске Тогда
		Если МаксимальныйРазмерФайла > 1024 Тогда
			
			ТекстОшибки = НСтр("ru = 'Максимальный размер файла превышает 1024 Мб'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "МаксимальныйРазмерФайла", , Отказ);
			
		КонецЕсли;
	КонецЕсли;
	
	Если НаборКонстант.ИспользоватьВУведомленияхВнешниеСсылки
		И НЕ ЗначениеЗаполнено(наборКонстант.АдресПубликацииИБНаВебСервере) Тогда
		
		ТекстОшибки = НСтр("ru = 'Для использования внешних ссылок в уведомлениях необходимо указать адрес публикации ИБ на веб-сервере'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "АдресПубликацииИБНаВебСервере", , Отказ);
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьПовторноИспользуемыеЗначения();
	ОбновитьИнтерфейс();
	
	Если ЗаголовокИзменен Тогда
		СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения();
		ЗаголовокИзменен = Ложь;
	КонецЕсли;
	
	ОповеститьОбИзмененииКонстант();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗаголовокСистемыПриИзменении(Элемент)
	
	ЗаголовокИзменен = Истина;
	
КонецПроцедуры

#Область СтраницаРаботасфайлами

&НаКлиенте
Процедура ЗапретЗагрузкиФайловПоРасширениюПриИзменении(Элемент)
	
	Элементы.СписокЗапрещенныхРасширений.Доступность = НаборКонстант.ЗапрещатьЗагрузкуФайловПоРасширению;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЭлектронныеЦифровыеПодписиПриИзменении(Элемент)
	
	Элементы.НастройкиЭЦП.Доступность = НаборКонстант.ИспользоватьЭлектронныеЦифровыеПодписи;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкиКриптографии(Команда)
	
	ПараметрыФормы = Новый Структура("ПоказыватьНастройкиШифрования", Истина);
	ОткрытьФорму("Общаяформа.НастройкиКриптографии", ПараметрыФормы,,,,, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаАдресатовУведомленийОСборках(Команда)
	
	ОткрытьФорму("ОбщаяФорма.НастройкаАдресатовУведомленийОСборках",, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьИзменениеКонстант(ТекущийОбъект)
	
	ИзмененныеКонстанты = Новый Структура;
	
	Для каждого Элемент Из Элементы Цикл
		Если ТипЗнч(Элемент) <> Тип("ПолеФормы") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВРег(Лев(Элемент.ПутьКДанным, СтрДлина("НаборКонстант."))) = ВРег("НаборКонстант.") Тогда
			ИмяКонстанты = Сред(Элемент.ПутьКДанным, СтрДлина("НаборКонстант.") + 1);
			
			Если ТипЗнч(ТекущийОбъект[ИмяКонстанты]) <> Тип("ХранилищеЗначения") Тогда
				
				СоставИзменений = Новый Структура;
				СоставИзменений.Вставить("НовоеЗначение",  ТекущийОбъект[ИмяКонстанты]);
				СоставИзменений.Вставить("СтароеЗначение", Константы[ИмяКонстанты].Получить());
				
				Если СоставИзменений.НовоеЗначение <> СоставИзменений.СтароеЗначение Тогда
					ИзмененныеКонстанты.Вставить(ИмяКонстанты, СоставИзменений);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОбИзмененииКонстант()
	
	Для каждого КлючИЗначение Из ИзмененныеКонстанты Цикл
		Оповестить("Запись_" + КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
