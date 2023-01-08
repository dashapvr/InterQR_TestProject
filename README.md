# InterQR_TestProject

1. Зробити програму з 1м екраном використовуючи swift 5+
2. Дизайн - https://www.figma.com/file/J3y4OhL1wMI3VTTrcNG5nT/Test-project?node-id=325%3A786
3. У додатку заборонено використовувати storyboards/xib крім launchScreen.
4. Для UI використовувати SnapKit.
5. Архітектура - MVC

Опис:
Екран є список дверей які можна відкрити клікнувши на комірку.
При старті програми зімітувати підвантаження по API списку дверей протягом 2-3 секунд, потім використовувати хардкодну модель.
При натисканні на комірку зімітувати виклик API, двері повинні прийняти "Unlocking..." статус на 3 секунди, потім "Unlocked" статус на 3 секунди, потім вихідний "Locked" статус.
Окремо прив'язати клік на "Locked" label, на кліку двері повинні так само відкриватися як описано вище.