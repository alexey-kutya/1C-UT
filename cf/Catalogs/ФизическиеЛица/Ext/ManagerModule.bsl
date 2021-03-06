﻿
Процедура ОткрытьПользователя(ФизЛицо,ВызовИзФизЛица = Ложь) Экспорт
	 
	Если ЗначениеЗаполнено(ФизЛицо) Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	Пользователи.Ссылка
		                      |ИЗ
		                      |	Справочник.Пользователи КАК Пользователи
		                      |ГДЕ
		                      |	Пользователи.ФизЛицо = &ФизЛицо");
							  
		
		Запрос.УстановитьПараметр("ФизЛицо",ФизЛицо);
		Результат =  Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Если Выборка.Следующий() Тогда
			
			Объект =  Выборка.Ссылка;
			Форма = Объект.ПолучитьФорму();
			Форма.ТолькоПросмотр = Истина;
			Форма.Открыть();
			
		Иначе
#Если Клиент Тогда			
			Предупреждение("Нет пользователя ИБ, соответствующего текущему Физ. лицу: <" + ФизЛицо + ">");
#КонецЕсли			
		КонецЕсли;
	Иначе
		
		Если ВызовИзФизЛица  Тогда
			
			Текст = "Сначала необходимо записать элемент справочника";
			
		Иначе
			
			Текст = "Сначала необходимо заполнить реквизит <Физ. лицо>";
			
		КонецЕсли;	
#Если Клиент Тогда		
		Предупреждение(Текст);
#КонецЕсли		
	КонецЕсли; 

КонецПроцедуры // ОткрытьПользователя() Экспорт
