﻿&НаКлиенте
Перем ЗаданиеАктивно;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	АдресХранилища = Параметры.АдресХранилища;
	
	Элементы.Закрыть.Доступность = Не Параметры.РежимПроверки;
	
	НачатьОбработкуЗапросов(
		Параметры.Идентификаторы,
		Параметры.РежимВключения,
		Параметры.РежимОтключения,
		Параметры.РежимВосстановления,
		Параметры.РежимПроверки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаданиеАктивно = Истина;
	ИтерацияПроверки = 1;
	ПодключитьОбработчикОжиданияОбработкиЗапросов(3);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЗаданиеАктивно Тогда
		
		ОтменитьОбработкуЗапросов(ИдентификаторЗадания);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция НачатьОбработкуЗапросов(Знач Запросы, Знач РежимВключения, РежимОтключения, Знач РежимВосстановления, Знач РежимПроверкиПрименения)
	
	ПоместитьВоВременноеХранилище(Неопределено, АдресХранилища);
	
	Если РежимВключения Тогда
		
		ПараметрыЗадания = Новый Массив();
		ПараметрыЗадания.Добавить(АдресХранилища);
		
		ПараметрыВызоваМетода = Новый Массив();
		ПараметрыВызоваМетода.Добавить("Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ВыполнитьОбработкуЗапросовОбновления");
		ПараметрыВызоваМетода.Добавить(ПараметрыЗадания);
		
	ИначеЕсли РежимОтключения Тогда
		
		ПараметрыЗадания = Новый Массив();
		ПараметрыЗадания.Добавить(АдресХранилища);
		
		ПараметрыВызоваМетода = Новый Массив();
		ПараметрыВызоваМетода.Добавить("Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ВыполнитьОбработкуЗапросовОтключения");
		ПараметрыВызоваМетода.Добавить(ПараметрыЗадания);
		
	ИначеЕсли РежимВосстановления Тогда
		
		ПараметрыЗадания = Новый Массив();
		ПараметрыЗадания.Добавить(АдресХранилища);
		
		ПараметрыВызоваМетода = Новый Массив();
		ПараметрыВызоваМетода.Добавить("Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ВыполнитьОбработкуЗапросовВосстановления");
		ПараметрыВызоваМетода.Добавить(ПараметрыЗадания);
		
	ИначеЕсли РежимПроверкиПрименения Тогда
		
		ПараметрыЗадания = Новый Массив();
		ПараметрыЗадания.Добавить(АдресХранилища);
		
		ПараметрыВызоваМетода = Новый Массив();
		ПараметрыВызоваМетода.Добавить("Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ВыполнитьОбработкуЗапросовПроверкиПрименения");
		ПараметрыВызоваМетода.Добавить(ПараметрыЗадания);
		
	Иначе
		
		ПараметрыЗадания = Новый Массив();
		ПараметрыЗадания.Добавить(Запросы);
		ПараметрыЗадания.Добавить(АдресХранилища);
		
		ПараметрыВызоваМетода = Новый Массив();
		ПараметрыВызоваМетода.Добавить("Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ВыполнитьОбработкуЗапросов");
		ПараметрыВызоваМетода.Добавить(ПараметрыЗадания);
		
	КонецЕсли;
	
	Задание = ФоновыеЗадания.Выполнить("РаботаВБезопасномРежиме.ВыполнитьМетодКонфигурации",
			ПараметрыВызоваМетода,
			,
			НСтр("ru = 'Обработка запросов на использование внешних ресурсов...'"));
	
	ИдентификаторЗадания = Задание.УникальныйИдентификатор;
	
	Возврат АдресХранилища;
	
КонецФункции

&НаКлиенте
Процедура ПроверитьОбработкуЗапросов()
	
	Попытка
		Готовность = ЗапросыОбработаны(ИдентификаторЗадания);
	Исключение
		ЗаданиеАктивно = Ложь;
		Закрыть(КодВозвратаДиалога.Отмена);
		ВызватьИсключение;
	КонецПопытки;
	
	Если Готовность Тогда
		ЗаданиеАктивно = Ложь;
		ЗавершитьОбработкуЗапросов();
	Иначе
		
		ИтерацияПроверки = ИтерацияПроверки + 1;
		
		Если ИтерацияПроверки = 2 Тогда
			ПодключитьОбработчикОжиданияОбработкиЗапросов(5);
		ИначеЕсли ИтерацияПроверки = 3 Тогда
			ПодключитьОбработчикОжиданияОбработкиЗапросов(8);
		Иначе
			ПодключитьОбработчикОжиданияОбработкиЗапросов(10);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапросыОбработаны(Знач ИдентификаторЗадания)
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	
	Если Задание <> Неопределено
		И Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Если Задание = Неопределено Тогда
		ВызватьИсключение(НСтр("ru = 'При обработке запросов произошла ошибка - не найдено задание обработки запросов.'"));
	КонецЕсли;
	
	Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
		ОшибкаЗадания = Задание.ИнформацияОбОшибке;
		Если ОшибкаЗадания <> Неопределено Тогда
			ВызватьИсключение(ПодробноеПредставлениеОшибки(ОшибкаЗадания));
		Иначе
			ВызватьИсключение(НСтр("ru = 'При обработке запросов произошла ошибка - задание обработки запросов завершилось с неизвестной ошибкой.'"));
		КонецЕсли;
	ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
		ВызватьИсключение(НСтр("ru = 'При обработке запросов произошла ошибка - задание обработки запросов было отменено администратором.'"));
	Иначе
		ИдентификаторЗадания = Неопределено;
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ЗавершитьОбработкуЗапросов()
	
	ЗаданиеАктивно = Ложь;
	
	Если Открыта() Тогда
		
		Закрыть(КодВозвратаДиалога.ОК);
		
	Иначе
		
		ОписаниеОповещения = ЭтотОбъект.ОписаниеОповещенияОЗакрытии;
		Если ОписаниеОповещения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.ОК);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьОбработкуЗапросов(Знач ИдентификаторЗадания)
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	
	Если Задание = Неопределено ИЛИ Задание.Состояние <> СостояниеФоновогоЗадания.Активно Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		Задание.Отменить();
	Исключение
		// Возможно задание как раз в этот момент закончилось и ошибки нет
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Настройка разрешений на использование внешних ресурсов.Отмена выполнения фонового задания'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОбработчикОжиданияОбработкиЗапросов(Знач Интервал)
	
	ПодключитьОбработчикОжидания("ПроверитьОбработкуЗапросов", Интервал, Истина);
	
КонецПроцедуры

#КонецОбласти