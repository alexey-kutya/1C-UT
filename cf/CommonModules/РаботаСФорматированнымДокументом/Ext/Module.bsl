﻿////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает шрифт используемый по умолчанию
//
// Возвращаемое значение:
//   Шрифт   - шрифт используемый по умолчанию
//
Функция ШрифтПоУмолчанию() Экспорт

	Возврат Новый Шрифт("Arial", 10);

КонецФункции

// Возращает шрифт форматированного текста
//
// Параметры:
//  Проект	- СправочникСсылка.Проекты - проект для которого задан шрифт
//
Функция ШрифтФорматированногоТекста() Экспорт
	
	Шрифт = Константы.ШрифтФорматированногоТекста.Получить().Получить();
	
	Если Шрифт = Неопределено Тогда
		Шрифт = ШрифтПоУмолчанию();
	КонецЕсли; 
	
	Возврат Шрифт;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
