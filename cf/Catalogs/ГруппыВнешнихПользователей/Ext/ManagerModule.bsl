﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("ТипОбъектовАвторизации");
	НеРедактируемыеРеквизиты.Добавить("ВсеОбъектыАвторизации");
	НеРедактируемыеРеквизиты.Добавить("Роли.УдалитьРоль");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#КонецЕсли
