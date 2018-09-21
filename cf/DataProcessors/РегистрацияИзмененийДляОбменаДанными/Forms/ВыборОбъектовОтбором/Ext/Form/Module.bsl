﻿
#Область ОбработчикиСобытийФормы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИмяТаблицыДанных = Параметры.ИмяТаблицы;
	ТекущийОбъект = ЭтотОбъект();
	ЗаголовокТаблицы  = "";
	
	// Определяемся, что за таблица к нам пришла
	Описание = ТекущийОбъект.ХарактеристикиПоМетаданным(ИмяТаблицыДанных);
	МетаИнфо = Описание.Метаданные;
	Заголовок = МетаИнфо.Представление();
	
	// Список и колонки
	СтруктураДанных = "";
	Если Описание.ЭтоСсылка Тогда
		ЗаголовокТаблицы = МетаИнфо.ПредставлениеОбъекта;
		Если ПустаяСтрока(ЗаголовокТаблицы) Тогда
			ЗаголовокТаблицы = Заголовок;
		КонецЕсли;
		
		СписокДанных.ПроизвольныйЗапрос = Ложь;
		СписокДанных.ОсновнаяТаблица = ИмяТаблицыДанных;
		
		Поле = СписокДанных.Отбор.ДоступныеПоляОтбора.Элементы.Найти(Новый ПолеКомпоновкиДанных("Ссылка"));
		ТаблицаКолонок = Новый ТаблицаЗначений;
		Колонки = ТаблицаКолонок.Колонки;
		Колонки.Добавить("Ссылка", Поле.ТипЗначения, ЗаголовокТаблицы);
		СтруктураДанных = "Ссылка";
		
		КлючФормыДанных = "Ссылка";
		
	ИначеЕсли Описание.ЭтоНабор Тогда
		Колонки = ТекущийОбъект.ИзмеренияНабораЗаписей(МетаИнфо);
		Для Каждого ТекЭл Из Колонки Цикл
			СтруктураДанных = СтруктураДанных + "," + ТекЭл.Имя;
		КонецЦикла;
		СтруктураДанных = Сред(СтруктураДанных, 2);
		
		СписокДанных.ПроизвольныйЗапрос = Истина;
		СписокДанных.ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ " + СтруктураДанных + " ИЗ " + ИмяТаблицыДанных;
		
		Если Описание.ЭтоПоследовательность Тогда
			КлючФормыДанных = "Регистратор";
		Иначе
			КлючФормыДанных = Новый Структура(СтруктураДанных);
		КонецЕсли;
			
	Иначе
		// Без колонок???
		Возврат;
	КонецЕсли;
	СписокДанных.ДинамическоеСчитываниеДанных = Истина;
	
	ТекущийОбъект.ДобавитьКолонкиВТаблицуФормы(
		Элементы.СписокДанных, 
		"Порядок, Отбор, Группировка, СтандартнаяКартинка, Параметры, УсловноеОформление",
		Колонки);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
//

&НаКлиенте
Процедура ОтборПриИзменении(Элемент)
	
	Элементы.СписокДанных.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДанных
//

&НаКлиенте
Процедура СписокДанныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуТекущегоОбъекта();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
//

&НаКлиенте
Процедура ОткрытьТекущийОбъект(Команда)
	ОткрытьФормуТекущегоОбъекта();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОтобранныеЗначения(Команда)
	ПроизвестиВыбор(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТекущуюСтроку(Команда)
	ПроизвестиВыбор(Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьФормуТекущегоОбъекта()
	ТекПараметры = ПараметрыФормыТекущегоОбъекта(Элементы.СписокДанных.ТекущиеДанные);
	Если ТекПараметры <> Неопределено Тогда
		ОткрытьФорму(ТекПараметры.ИмяФормы, ТекПараметры.Ключ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроизвестиВыбор(ВесьРезультатОтбора = Истина)
	
	Если ВесьРезультатОтбора Тогда
		Данные = ВсеВыбранныеЭлементы();
	Иначе
		Данные = Новый Массив;
		Для Каждого ТекСтрока Из Элементы.СписокДанных.ВыделенныеСтроки Цикл
			Элемент = Новый Структура(СтруктураДанных);
			ЗаполнитьЗначенияСвойств(Элемент, Элементы.СписокДанных.ДанныеСтроки(ТекСтрока));
			Данные.Добавить(Элемент);
		КонецЦикла;
	КонецЕсли;
	
	ОповеститьОВыборе(Новый Структура("ИмяТаблицы, ДанныеВыбора, ДействиеВыбора, СтруктураПолей",
		Параметры.ИмяТаблицы,
		Данные,
		Параметры.ДействиеВыбора,
		СтруктураДанных));
КонецПроцедуры

&НаСервере
Функция ЭтотОбъект(ТекущийОбъект = Неопределено) 
	Если ТекущийОбъект = Неопределено Тогда
		Возврат РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	Возврат Неопределено;
КонецФункции

&НаСервере
Функция ПараметрыФормыТекущегоОбъекта(Знач Данные)
	
	Если Данные = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(КлючФормыДанных) = Тип("Строка") Тогда
		Значение = Данные[КлючФормыДанных];
		ТекИмяФормы = ЭтотОбъект().ПолучитьИмяФормы(Значение) + ".ФормаОбъекта";
	Иначе
		// Там структура с именами измерений
		ТекИмяФормы = "";
		ЗаполнитьЗначенияСвойств(КлючФормыДанных, Данные);
		ТекПараметры = Новый Массив;
		ТекПараметры.Добавить(КлючФормыДанных);
		Попытка
			Значение = Новый(СтрЗаменить(Параметры.ИмяТаблицы, ".", "КлючЗаписи."), ТекПараметры);
			ТекИмяФормы = Параметры.ИмяТаблицы + ".ФормаЗаписи";
		Исключение
			// Обработка не требуется
			;
		КонецПопытки;
		
		Если ПустаяСтрока(ТекИмяФормы) Тогда
			// Набор без ключей записи, типа оборотного регистра
			Если Данные.Свойство("Регистратор") Тогда
				Значение = Данные.Регистратор;
			Иначе
				Для Каждого КлючЗначение Из КлючФормыДанных Цикл
					Значение = Данные[КлючЗначение.Ключ];
					Прервать;
				КонецЦикла;
			КонецЕсли;
			ТекИмяФормы = ЭтотОбъект().ПолучитьИмяФормы(Значение) + ".ФормаОбъекта";
		КонецЕсли;
	КонецЕсли;		
	
	Возврат Новый Структура("ИмяФормы, Ключ", 
		ТекИмяФормы, 
		Новый Структура("Ключ", Значение));
КонецФункции

&НаСервере
Функция ВсеВыбранныеЭлементы()
	
	Данные = ЭтотОбъект().ТекущиеДанныеДинамическогоСписка(СписокДанных);
	
	Результат = Новый Массив();
	Для Каждого ТекСтрока Из Данные Цикл
		Элемент = Новый Структура(СтруктураДанных);
		ЗаполнитьЗначенияСвойств(Элемент, ТекСтрока);
		Результат.Добавить(Элемент);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции	

#КонецОбласти
