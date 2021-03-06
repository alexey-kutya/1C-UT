﻿
&НаКлиенте
Процедура ПроверитьСоединение(Команда)
	
	Статус = ПроверитьСоединениеНаСервере();
	Если Статус  = "" Тогда
		       		
		РезультатПроверкиСоединения = "Соединение прошло успешно";
		
	Иначе
		
		РезультатПроверкиСоединения = Статус;
		
	КонецЕсли;

	ПоказатьПредупреждение(,РезультатПроверкиСоединения);
	
КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
&НаСервере
Функция ПроверитьСоединениеНаСервере()
	
	Если ПустаяСтрока(АдресSMTP)  Тогда
		
		ВызватьИсключение "Не указан адрес SMTP сервера";
		
	КонецЕсли;
	
	Если ПустаяСтрока(АдресPOP3)  Тогда
		
		ВызватьИсключение "Не указан адрес POP3 сервера";
		
	КонецЕсли;					
	
	Попытка
		ПочтовыйПрофиль = СоздатьПочтовыйПрофиль();
		
		Почта = Новый ИнтернетПочта;
		Почта.Подключиться(ПочтовыйПрофиль);
	Исключение
		ВызватьИсключение "Не удалось подключить с указанными параметрами " + ОписаниеОшибки();
	КонецПопытки;
	
	Возврат "";
						
КонецФункции // ()

// Функция получения соединения с сервером и создание почтового профиля.
//
// Параметры:
//    Нет.
//
// Возвращаемое значение:
//    Полученные почтовый профиль. Тип: ИнтернетПочтовыйПрофиль.
Функция СоздатьПочтовыйПрофиль() 
	
	// устанавливаем адрес SMPT
	Разделитель = Найти(АдресSMTP, ":");
	Если Разделитель > 0 Тогда
		АдресSMTP = Лев(АдресSMTP,Разделитель-1); 
		Попытка 
			ПортSMTP = Число(Сред(АдресSMTP,Разделитель+1));
		Исключение
			ПортSMTP = 25;
		КонецПопытки;
	Иначе
		АдресSMTP = АдресSMTP;
		ПортSMTP = 25;
	КонецЕсли;
	
	// устанавливаем адрес POP3
	Разделитель = Найти(АдресPOP3, ":");
	Если Разделитель > 0 Тогда
		АдресPOP3 = Лев(АдресPOP3,Разделитель-1); 
		Попытка 
			ПортPOP3 = Число(Сред(АдресPOP3,Разделитель+1));
		Исключение
			ПортPOP3 = 110;
		КонецПопытки;
	Иначе
		АдресPOP3 = АдресPOP3;
		ПортPOP3 = 110;
	КонецЕсли;
	
	
	ПочтовыйПрофиль = Новый ИнтернетПочтовыйПрофиль;
	
	Если ЗначениеЗаполнено(АдресSMTP) Тогда
		ПочтовыйПрофиль.АдресСервераSMTP = АдресSMTP;
		ПочтовыйПрофиль.ПортSMTP		 = Число(ПортSMTP);
		Если ЗначениеЗаполнено(ПользовательSMTP) Тогда
			ПочтовыйПрофиль.ПользовательSMTP = ПользовательSMTP;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПарольSMTP) Тогда
			ПочтовыйПрофиль.ПарольSMTP		 = ПарольSMTP;
		КонецЕсли;
		ПочтовыйПрофиль.АутентификацияSMTP = СпособSMTPАутентификации.БезАутентификации;
		//SMTPАутентификации = СпособSMTPАвторизации;
		//Если ЗначениеЗаполнено(SMTPАутентификации) Тогда
		//	ПочтовыйПрофиль.АутентификацияSMTP  = СпособSMTPАутентификации[SMTPАутентификации];
		//КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресPOP3) Тогда
		ПочтовыйПрофиль.АдресСервераPOP3 = АдресPOP3;
		ПочтовыйПрофиль.ПортPOP3		 = Число(ПортPOP3);
		ПочтовыйПрофиль.Пользователь	 = ПользовательPOP3;
		ПочтовыйПрофиль.Пароль			 = ПарольPOP3;
		//POP3Аутентификации 		         = СпособPOP3Авторизации;
		//Если ЗначениеЗаполнено(POP3Аутентификации) Тогда
		//	ПочтовыйПрофиль.АутентификацияPOP3   = СпособPOP3Аутентификации[POP3Аутентификации];
		//КонецЕсли;
	КонецЕсли;
		
	Возврат ПочтовыйПрофиль;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураПараметров = Константы.ХранилищеПараметровПочтовогоЯщика.Получить().Получить();
	Если ТипЗнч(СтруктураПараметров) = Тип("Структура") Тогда
		АдресОтправителя = СтруктураПараметров.АдресОтправителя;
		ИмяОтправителя = СтруктураПараметров.ИмяОтправителя;
		АдресSMTP = СтруктураПараметров.АдресSMTP;
		ПользовательSMTP = СтруктураПараметров.ПользовательSMTP;
		ПарольSMTP = СтруктураПараметров.ПарольSMTP;
		АдресPOP3 = СтруктураПараметров.АдресPOP3;
		ПользовательPOP3 = СтруктураПараметров.ПользовательPOP3;
		ПарольPOP3 = СтруктураПараметров.ПарольPOP3;
	КонецЕсли; 
	
КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура СохранитьНаСервере()

//	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.АдресОтправителя = АдресОтправителя;
	СтруктураПараметров.ИмяОтправителя = ИмяОтправителя;
	СтруктураПараметров.АдресSMTP = АдресSMTP;
	СтруктураПараметров.ПользовательSMTP = ПользовательSMTP;
	СтруктураПараметров.ПарольSMTP = ПарольSMTP;
	СтруктураПараметров.АдресPOP3 = АдресPOP3;
	СтруктураПараметров.ПользовательPOP3 = ПользовательPOP3;
	СтруктураПараметров.ПарольPOP3 = ПарольPOP3;
	
	//СтруктураПараметров.Вставить("АдресОтправителя", АдресОтправителя);
	//СтруктураПараметров.Вставить("ИмяОтправителя", ИмяОтправителя);
	//СтруктураПараметров.Вставить("АдресSMTP", АдресSMTP);
	//СтруктураПараметров.Вставить("ПользовательSMTP", ПользовательSMTP);
	//СтруктураПараметров.Вставить("ПарольSMTP", ПарольSMTP);
	//СтруктураПараметров.Вставить("АдресPOP3", АдресPOP3);
	//СтруктураПараметров.Вставить("ПользовательPOP3", ПользовательPOP3);
	//СтруктураПараметров.Вставить("ПарольPOP3", ПарольPOP3);
	
	Константы.ХранилищеПараметровПочтовогоЯщика.Установить(Новый ХранилищеЗначения(СтруктураПараметров));

КонецПроцедуры // СохранитьНаСервере()
 
&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьНаСервере();
КонецПроцедуры




