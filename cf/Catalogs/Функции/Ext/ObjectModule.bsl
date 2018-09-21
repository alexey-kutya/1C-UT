﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьИерархиюФункций(Отказ);
	
	Если Отказ Тогда
		ТекстСообщения = НСтр("ru='Функция '") + СтрЗаменить(ПолныйКод(), "/", ".") + " <" + Наименование + "> " + НСтр("ru='не записана.'") +Символы.ПС; 
		Сообщить(ТекстСообщения, СтатусСообщения.Важное);
		Возврат;
	КонецЕсли;
	
	ЗаписьСправочников.УстановитьКодСправочника(ЭтотОбъект);
	ЗаписьСправочников.УстановитьПолныйКодСправочника(ЭтотОбъект,СтрДлина(Строка(Код)));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьИерархиюФункций(Отказ)
	
	Если НЕ Родитель.Пустая() И Универсальные.ЗначенияРеквизитовСправочника(Родитель, "КонечнаяФункция").КонечнаяФункция Тогда
		Отказ = Истина;
		
		ПолныйКодФункции = СтрЗаменить(ПолныйКод(), "/", ".");
		ПолныйКодРодителя = СтрЗаменить(Родитель.ПолныйКод(), "/", ".");
		
		ТекстСообщения = НСтр("ru='Функция %ПолныйКод% <%Наименование%> не может подчиняться конечной функции %ПолныйКодРодителя% %Родитель%.'");
		ТекстСообщения = ТекстСообщения + Символы.ПС + НСтр("ru='Необходимо отключить у родительской функции признак ""Конечная функция"".'");
		
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПолныйКод%", ПолныйКодФункции);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Наименование%", Наименование);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПолныйКодРодителя%", ПолныйКодРодителя);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Родитель%", Родитель);
		
		Сообщить(ТекстСообщения, СтатусСообщения.Важное);
	КонецЕсли;
	
	Если КонечнаяФункция И НЕ ЭтоНовый() Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Функции.Ссылка
		|ИЗ
		|	Справочник.Функции КАК Функции
		|ГДЕ
		|	Функции.Родитель = &Родитель";
		
		Запрос.УстановитьПараметр("Родитель", Ссылка);
		
		Если НЕ Запрос.Выполнить().Пустой() Тогда
			Отказ = Истина;
			
			ПолныйКодФункции = СтрЗаменить(ПолныйКод(), "/", ".");
			
			ТекстСообщения = НСтр("ru='Конечная функция %ПолныйКод% <%Наименование%> не может иметь дочерние функции.'");
			ТекстСообщения = ТекстСообщения + Символы.ПС + НСтр("ru='Необходимо отключить у функции признак ""Конечная функция"".'");
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПолныйКод%", ПолныйКодФункции);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Наименование%", Наименование);
			
			Сообщить(ТекстСообщения, СтатусСообщения.Важное);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли