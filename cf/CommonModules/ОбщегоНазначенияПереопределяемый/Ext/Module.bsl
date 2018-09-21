﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает соответствие имен параметров сеанса и обработчиков для их инициализации.
//
// Для задания обработчиков параметров сеанса следует использовать шаблон:
// Обработчики.Вставить("<ИмяПараметраСеанса>|<НачалоИмениПараметраСеанса*>", "Обработчик");
//
// Примечание. Символ '*'используется в конце имени параметра сеанса и обозначает,
//             что один обработчик будет вызван для инициализации всех параметров сеанса
//             с именем, начинающимся на слово НачалоИмениПараметраСеанса
//
Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	
КонецПроцедуры

// Объекты метаданных, содержимое которых не должно учитывается в бизнес-логике приложения.
//
// Описание:
//   Для документа "Реализация товаров и услуг" настроены подсистемы "Версионирование объектов" и "Свойства".
//   При этом документ может быть указан в других объектах метаданных - документах или регистрах.
//   Часть ссылок имеют значение для бизнес-логики (например движения по регистрам) и должны выводиться пользователю.
//   Другая часть ссылок - "техногенные" ссылки на документ из данных подсистем "Версионирование объектов" и "Свойства",
//     должны скрываться от пользователя при поиске ссылок на объект. 
//     Например, при анализе мест использования или в подсистеме запрета редактирования ключевых реквизитов.
//   Список таких "техногенных" объектов нужно перечислить в этой процедуре.
//
// Важно:
//   Для избежания появления пустых "битых" ссылок рекомендуется предусмотреть процедуру очистки указанных объектов метаданных.
//   Для измерений регистров сведений - с помощью установки флажка "Ведущее",
//     тогда запись регистра сведений будет удалена вместе с удалением ссылки, указанной в измерении.
//   Для других реквизитов указанных объектов - с помощью подписки на событие ПередУдалением всех типов объектов метаданных,
//     которые могут быть записаны в реквизиты указанных объектов метаданных.
//     В обработчике необходимо найти "техногенные" объекты, в реквизитах которых указана ссылка удаляемого объекта,
//     и выбрать как именно очищать ссылку: очищать значение реквизита, удалять строку таблицы или удалять весь объект.
//
// Параметры:
//  ИсключенияПоискаСсылок - Массив - Объекты метаданных или их реквизиты, содержимое которых не должно учитывается в бизнес-логике приложения.
//   * ОбъектМетаданных - Объект метаданных или его реквизит.
//   * Строка - Полное имя объекта метаданных или его реквизита.
//
// Примеры:
//	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов);
//	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов.Реквизиты.АвторВерсии);
//	ИсключенияПоискаСсылок.Добавить("РегистрСведений.ВерсииОбъектов");
//
Процедура ПриДобавленииИсключенийПоискаСсылок(ИсключенияПоискаСсылок) Экспорт
	
КонецПроцедуры

// Устанавливает текстовое описание предмета
//
// Параметры
//  СсылкаНаПредмет  - ЛюбаяСсылка - объект ссылочного типа.
//  Представление	 - Строка - сюда необходимо поместить текстовое описание.
Процедура УстановитьПредставлениеПредмета(СсылкаНаПредмет, Представление) Экспорт
	
КонецПроцедуры

// Доопределяет переименования тех объектов метаданных, которые невозможно
// автоматически найти по типу, но ссылки на которые требуется сохранять
// в базе данных (например: подсистемы, роли).
//
// Параметры:
//  Итог - ТаблицаЗначений - таблица, которую нужно передавать, как параметр
//         в процедуру ДобавитьПереименование общего модуля ОбщегоНазначения.
//
// Пример:
//	ОбщегоНазначения.ДобавитьПереименование(Итог, "2.2.1.7",
//		"Роль.ИспользованиеЭЦП", "Роль.ИспользованиеЭП", "СтандартныеПодсистемы");
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	
КонецПроцедуры

// Возвращает структуру параметров, необходимых для работы клиентского кода
// при запуске конфигурации, т.е. в обработчиках событий
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы
//
// Важно: при запуске недопустимо использовать команды сброса кэша
// повторно используемых модулей, иначе запуск может привести
// к непредсказуемым ошибкам и лишним серверным вызовам
//
// Параметры:
//   Параметры - Структура - (возвращаемое значение) структура параметров работы клиента при запуске.
//
// Пример реализации:
//   Для установки параметров работы клиента можно использовать шаблон:
//
//     Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
//
Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	
КонецПроцедуры

// Возвращает структуру параметров, необходимых для работы клиентского кода
// конфигурации.
//
// Параметры:
//   Параметры - Структура - (возвращаемое значение) структура параметров работы клиента.
//
// Пример реализации:
//   Для установки параметров работы клиента можно использовать шаблон:
//
//     Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПараметрыРаботыКлиента(Параметры) Экспорт
	
КонецПроцедуры

// Возвращает структуру параметров, необходимых для работы клиентского кода
// конфигурации при завершении, т.е. в обработчиках:
// - ПередЗавершениемРаботыСистемы,
// - ПриЗавершенииРаботыСистемы
//
// Параметры:
//   Параметры - Структура - (возвращаемое значение) структура параметров работы клиента при завершении.
//
// Пример реализации:
//   Для установки параметров работы клиента при завершении можно использовать шаблон:
//
//     Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПараметрыРаботыКлиентаПриЗавершении(Параметры) Экспорт
	
КонецПроцедуры

// Позволяет настроить общие параметры подсистемы.
//
// Параметры:
//  ОбщиеПараметры - Структура - структура со свойствами:
//      * ИмяФормыПерсональныхНастроек            - Строка - имя формы для редактирования персональных настроек.
//                                                           Ранее определялись в ОбщегоНазначенияПереопределяемый.ИмяФормыПерсональныхНастроек.
//      * МинимальноНеобходимаяВерсияПлатформы    - Строка - полный номер версии платформы для запуска программы. Например, "8.3.4.365".
//                                                           Ранее определялись в ОбщегоНазначенияПереопределяемый.ПолучитьМинимальноНеобходимуюВерсиюПлатформы.
//      * РаботаВПрограммеЗапрещена               - Булево - Начальное значение Ложь.
//      * ЗапрашиватьПодтверждениеПриЗавершенииПрограммы - Булево - по умолчанию Истина. Если установить Ложь, то 
//                                                                  подтверждение при завершении работы программы не будет запрашиваться, 
//                                                                  если явно не разрешить в персональных настройках программы.
//      * ОтключитьСправочникИдентификаторыОбъектовМетаданных - Булево - отключает заполнение справочника
//              ИдентификаторыОбъектовМетаданных, процедуры выгрузки и загрузки элементов справочника в узлах РИБ.
//              Для частичного встраивании отдельных функций библиотеки в конфигурации без постановки на поддержку.
//
Процедура ПриОпределенииОбщихПараметровБазовойФункциональности(ОбщиеПараметры) Экспорт
	
	
КонецПроцедуры

// Обработчик события "Перед загрузкой идентификаторов объектов метаданных в подчиненном РИБ узле".
// Выполняет заполнение настроек размещения сообщения обмена данными или
// нестандартную загрузку идентификаторов объектов метаданных из главного узла.
//
// Параметры:
//  СтандартнаяОбработка - Булево, начальное значение Истина, если установить Ложь, тогда стандартная загрузка
//                идентификаторов объектов метаданных с помощью подсистемы ОбменДанными будет пропущена (тоже
//                будет и в случае, если подсистемы ОбменДанными нет).
//
Процедура ПередЗагрузкойИдентификаторовОбъектовМетаданныхВПодчиненномРИБУзле(СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// Заполняет структуру массивами поддерживаемых версий всех подлежащих версионированию программных интерфейсов,
// используя в качестве ключей имена программных интерфейсов.
// Обеспечивает функциональность Web-сервиса InterfaceVersion.
// При внедрении надо поменять тело процедуры так, чтобы она возвращала актуальные наборы версий (см. пример.ниже).
//
// Параметры:
// СтруктураПоддерживаемыхВерсий - Структура:
//  Ключ - Имя программного интерфейса,
//  Значение - Массив(Строка) - поддерживаемые версии программного интерфейса.
//
// Пример реализации:
//
//  // СервисПередачиФайлов
//  МассивВерсий = Новый Массив;
//  МассивВерсий.Добавить("1.0.1.1");
//  МассивВерсий.Добавить("1.0.2.1"); 
//  СтруктураПоддерживаемыхВерсий.Вставить("СервисПередачиФайлов", МассивВерсий);
//  // Конец СервисПередачиФайлов
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(СтруктураПоддерживаемыхВерсий) Экспорт
	
КонецПроцедуры

// Параметры функциональных опций, действие которых распространяется на командный интерфейс и рабочий стол.
//   Например, если значения функциональной опции хранятся в ресурсах регистра сведений,
//   то параметры функциональных опций могут определять условия отборов по измерениям регистра,
//   которые будут применяться при чтении значения этой функциональной опции.
//
// Параметры:
//   ОпцииИнтерфейса - Структура - Значения параметров функциональных опций, установленных для командного интерфейса.
//       Ключ элемента структуры определяет имя параметра, а значение элемента - текущее значение параметра.
//
// См. также:
//   Методы глобального контекста ПолучитьФункциональнуюОпциюИнтерфейса(),
//   УстановитьПараметрыФункциональныхОпцийИнтерфейса() и ПолучитьПараметрыФункциональныхОпцийИнтерфейса().
//
Процедура ПриОпределенииПараметровФункциональныхОпцийИнтерфейса(ОпцииИнтерфейса) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Устаревший программный интерфейс

// Устарела. Будет удалена в следующей редакции. См. ПриОпределенииОбщихПараметровБазовойФункциональности.
Процедура ИмяФормыПерсональныхНастроек(ИмяФормы) Экспорт
	
КонецПроцедуры

// Устарела. Будет удалена в следующей редакции. См. ПриОпределенииОбщихПараметровБазовойФункциональности.
Процедура ПолучитьМинимальноНеобходимуюВерсиюПлатформы(ПараметрыПроверки) Экспорт
	
КонецПроцедуры

// Устарела. Будет удалена в следующей редакции. См. ПриДобавленииПереименованийОбъектовМетаданных.
Процедура ЗаполнитьТаблицуПереименованияОбъектовМетаданных(Итог) Экспорт
	
КонецПроцедуры

// Устарела. Следует использовать ПриДобавленииОбработчиковУстановкиПараметровСеанса.
// Возвращает соответствие имен параметров сеанса и обработчиков для их инициализации.
//
Функция ОбработчикиИнициализацииПараметровСеанса() Экспорт
	
	// Для задания обработчиков параметров сеанса следует использовать шаблон:
	// Обработчики.Вставить("<ИмяПараметраСеанса>|<НачалоИмениПараметраСеанса*>", "Обработчик");
	//
	// Примечание. Символ '*'используется в конце имени параметра сеанса и обозначает,
	//             что один обработчик будет вызван для инициализации всех параметров сеанса
	//             с именем, начинающимся на слово НачалоИмениПараметраСеанса
	//
	
	Обработчики = Новый Соответствие;
	
	Возврат Обработчики;
	
КонецФункции

// Устарела. Следует использовать ПриДобавленииИсключенийПоискаСсылок.
//
// Объекты метаданных, содержимое которых не должно учитывается в бизнес-логике приложения.
//
// Описание:
//   Для документа "Реализация товаров и услуг" настроены подсистемы "Версионирование объектов" и "Свойства".
//   При этом документ может быть указан в других объектах метаданных - документах или регистрах.
//   Часть ссылок имеют значение для бизнес-логики (например движения по регистрам) и должны выводиться пользователю.
//   Другая часть ссылок - "техногенные" ссылки на документ из данных подсистем "Версионирование объектов" и "Свойства",
//     должны скрываться от пользователя при поиске ссылок на объект. 
//     Например, при анализе мест использования или в подсистеме запрета редактирования ключевых реквизитов.
//   Список таких "техногенных" объектов нужно перечислить в этой функции.
//
// Важно:
//   Для избежания появления пустых "битых" ссылок рекомендуется предусмотреть процедуру очистки указанных объектов метаданных.
//   Для измерений регистров сведений - с помощью установки флажка "Ведущее",
//     тогда запись регистра сведений будет удалена вместе с удалением ссылки, указанной в измерении.
//   Для других реквизитов указанных объектов - с помощью подписки на событие ПередУдалением всех типов объектов метаданных,
//     которые могут быть записаны в реквизиты указанных объектов метаданных.
//     В обработчике необходимо найти "техногенные" объекты, в реквизитах которых указана ссылка удаляемого объекта,
//     и выбрать как именно очищать ссылку: очищать значение реквизита, удалять строку таблицы или удалять весь объект.
//
// Например:
//	Массив.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов);
//	Массив.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов.Реквизиты.АвторВерсии);
//	Массив.Добавить("РегистрСведений.ВерсииОбъектов");
//
// Возвращаемое значение:
//   Массив - Объекты метаданных или их реквизиты, содержимое которых не должно учитывается в бизнес-логике приложения.
//       * ОбъектМетаданных - Объект метаданных или его реквизит.
//       * Строка - Полное имя объекта метаданных или его реквизита.
//
Функция ПолучитьИсключенияПоискаСсылок() Экспорт
	
	Массив = Новый Массив;
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти
