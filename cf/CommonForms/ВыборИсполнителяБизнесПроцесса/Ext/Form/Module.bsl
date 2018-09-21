﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.ТолькоПростыеРоли Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СписокРоли, "ИспользуетсяБезОбъектовАдресации", Истина,,Истина);
	КонецЕсли;	
	Если Параметры.БезВнешнихРолей = Истина Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СписокРоли, "ВнешняяРоль", Ложь);
	КонецЕсли;	
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(СписокПользователи, "ПустойУникальныйИдентификатор", 
		Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	Если ТипЗнч(Параметры.Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда
		
		ТекущийЭлемент = Элементы.СписокПользователи;
		Элементы.СписокПользователи.ТекущаяСтрока = Параметры.Исполнитель;
		
	ИначеЕсли ТипЗнч(Параметры.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.Роли;
		ТекущийЭлемент = Элементы.СписокРоли;
		Элементы.СписокРоли.ТекущаяСтрока = Параметры.Исполнитель;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ВыборРолиИсполнителя") Тогда
		Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
			ОповеститьОВыборе(ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокРоли

&НаКлиенте
Процедура СписокПользователиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРолиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборРоли(Элемент.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Пользователи Тогда 
		ОповеститьОВыборе(Элементы.СписокПользователи.ТекущаяСтрока);
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Роли Тогда 
		ВыборРоли(Элементы.СписокРоли.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ВыборРоли(ТекущиеДанные)
	
	Если ТекущиеДанные.ИспользуетсяСОбъектамиАдресации Тогда 
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РольИсполнителя",               ТекущиеДанные.Ссылка);
		ПараметрыФормы.Вставить("ОсновнойОбъектАдресации",       Неопределено);
		ПараметрыФормы.Вставить("ДополнительныйОбъектАдресации", Неопределено);
		ПараметрыФормы.Вставить("ВыборОбъектаАдресации",         Истина);
		ОткрытьФорму("ОбщаяФорма.ВыборРолиИсполнителя", ПараметрыФормы, ЭтотОбъект);
	Иначе
		ВыбранноеЗначение = Новый Структура("РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации", ТекущиеДанные.Ссылка, Неопределено, Неопределено);
		ОповеститьОВыборе(ВыбранноеЗначение);
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗначениеПараметраКомпоновкиДанных(Знач ВладелецПараметров, Знач ИмяПараметра, Знач ЗначениеПараметра)
	
	Для каждого Параметр Из ВладелецПараметров.Параметры.Элементы Цикл
		Если Строка(Параметр.Параметр) = ИмяПараметра Тогда
			Если Параметр.Использование И Параметр.Значение = ЗначениеПараметра Тогда
				Возврат;
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ВладелецПараметров.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра);
	
КонецПроцедуры

#КонецОбласти
