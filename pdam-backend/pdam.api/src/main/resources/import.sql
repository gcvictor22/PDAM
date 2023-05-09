insert into city (id, name, location) values (1,'A Coruña', '43,37012643/-8,39114853');
insert into city (id, name, location) values (2,'Albacete', '38,99588053/-1,85574745');
insert into city (id, name, location) values (3,'Alicante', '38,34548705/-0,4831832');
insert into city (id, name, location) values (4,'Almería', '36,83892362/-2,46413188');
insert into city (id, name, location) values (5,'Álava', '42,85058789/-2,67275685');
insert into city (id, name, location) values (6,'Ávila', '40,65586958/-4,69771277');
insert into city (id, name, location) values (7,'Badajoz', '38,87874339/-6,97099704');
insert into city (id, name, location) values (8,'Barcelona', '41,38424664/2,17634927');
insert into city (id, name, location) values (9,'Vizcaya', '43,25721957/-2,92390606');
insert into city (id, name, location) values (10,'Burgos', '42,34113004/-3,70419805');
insert into city (id, name, location) values (11,'Cáceres', '39,47316762/-6,37121092');
insert into city (id, name, location) values (12,'Cádiz', '36,52171152/-6,28414575');
insert into city (id, name, location) values (13,'Cantabria', '43,46297885/-3,80474784');
insert into city (id, name, location) values (14,'Castellón', '39,98640809/-0,03688142');
insert into city (id, name, location) values (15,'Ceuta', '35,88810209/-5,30675127');
insert into city (id, name, location) values (16,'Ciudad Real', '38,98651781/-3,93131981');
insert into city (id, name, location) values (17,'Córdoba', '37,87954225/-4,78032455');
insert into city (id, name, location) values (18,'Cuenca', '40,07653762/-2,13152306');
insert into city (id, name, location) values (19,'Gipuzkoa', '43,31717158/-1,98191785');
insert into city (id, name, location) values (20,'Girona', '41,98186075/2,82411899');
insert into city (id, name, location) values (21,'Granada', '37,17641932/-3,60001883');
insert into city (id, name, location) values (22,'Guadalajara', '40,63435548/-3,16210273');
insert into city (id, name, location) values (23,'Huelva', '37,26004113/-6,95040588');
insert into city (id, name, location) values (24,'Huesca', '42,14062739/-0,40842276');
insert into city (id, name, location) values (25,'Islas Baleares,', '39,57114699/2,65181698');
insert into city (id, name, location) values (26,'Jaén', '37,7651913/-3,7903594');
insert into city (id, name, location) values (27,'Las Palmas', '28,099378545/-15,413368411');
insert into city (id, name, location) values (28,'León', '42,59912097/-5,56707631');
insert into city (id, name, location) values (29,'Lleida', '41,61527355/0,62061934');
insert into city (id, name, location) values (30,'La Rioja', '42,46644945/-2,44565538');
insert into city (id, name, location) values (31,'Lugo', '43,0091282/-7,55817392');
insert into city (id, name, location) values (32,'Madrid', '40,40841191/-3,68760088');
insert into city (id, name, location) values (33,'Málaga', '36,72034267/-4,41997511');
insert into city (id, name, location) values (34,'Melilla', '35,294731/-2,942281');
insert into city (id, name, location) values (35,'Murcia', '37,98436361/-1,1285408');
insert into city (id, name, location) values (36,'Navarra', '42,814102/-1,6451528');
insert into city (id, name, location) values (37,'Ourense', '42,33654919/-7,86368375');
insert into city (id, name, location) values (38,'Oviedo', '43,36232165/-5,84372206');
insert into city (id, name, location) values (39,'Palencia', '42,0078373/-4,53460106');
insert into city (id, name, location) values (40,'Pontevedra', '42,43381442/-8,64799018');
insert into city (id, name, location) values (41,'Salamanca', '40,96736822/-5,66538084');
insert into city (id, name, location) values (42,'Santa Cruz de Tenerife', '28,462854082/-16,247206286');
insert into city (id, name, location) values (43,'Segovia', '40,9498703/-4,12524116');
insert into city (id, name, location) values (44,'Sevilla', '37,38620512/-5,99251368');
insert into city (id, name, location) values (45,'Soria', '41,76327912/-2,46624798');
insert into city (id, name, location) values (46,'Tarragona', '41,11910287/1,2584219');
insert into city (id, name, location) values (47,'Teruel', '40,34412951/-1,10927177');
insert into city (id, name, location) values (48,'Toledo', '39,85715187/-4,02431421');
insert into city (id, name, location) values (49,'Valencia', '39,47534441/-0,37565717');
insert into city (id, name, location) values (50,'Valladolid', '41,65232777/-4,72334924');
insert into city (id, name, location) values (51,'Zamora', '41,49913956/-5,75494831');
insert into city (id, name, location) values (52,'Zaragoza', '41,65645655/-0,87928652');

insert into gender (id, name) values (63, 'Male');
insert into gender (id, name) values (64, 'Female');
insert into gender (id, name) values (65, 'Other');

insert into user_entity (full_name, user_name, email, id, phone_number, password, img_path, verified, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at, roles, authorized, city, gender) values ('Rhoda Blayney', 'rblayney0', 'rblayney0@shinystat.com', '1de440c9-6c02-5d77-8586-bc6a7ad216ed', '984113814', '{bcrypt}$2a$10$cPOngwJ8p10s6iUrR17cIuiy.JsKCJe6h8ql569SzeswYM8jPPjW2', 'default.jpeg', false, true, true, true, true, '2022-07-20', '2022-10-26', 'USER', false, 44, 64); --THoGYvZF9Vh.
insert into user_entity (full_name, user_name, email, id, phone_number, password, img_path, verified, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at, roles, authorized, city, gender) values ('Mack Antonoyev', 'mantonoyev1', 'mantonoyev1@google.es', '8ee56ea7-ce36-595c-bfb4-b5fd87e34b09', '973145646', '{bcrypt}$2a$10$ApSMXPShH3jBFbPT.K9FyeesyyivT4udGyVIh3WccMn9ibNLF9Tge', 'default.jpeg', false, true, true, true, true, '2022-03-01', '2022-07-17', 'USER', false, 31, 63); -- KYKvrVgd2.
insert into user_entity (full_name, user_name, email, id, phone_number, password, img_path, verified, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at, roles, authorized, city, gender) values ('Aldon Whitsey', 'awhitsey2', 'awhitsey2@ox.ac.uk', 'df442a4d-2ec0-54b6-ab24-019787533d25', '469989018', '{bcrypt}$2a$10$u/S0IIP0gLEAwREvxIhN4ejItaagYHT.tVdXFDTNOy.1ylpNpCtBO', 'default.jpeg', false, true, true, true, true, '2022-05-12', '2022-06-25', 'USER', false, 28, 63); --Rf9j1QmhQY.
insert into user_entity (full_name, user_name, email, id, phone_number, password, img_path, verified, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at, roles, authorized, city, gender) values ('Alica Dederick', 'adederick3', 'adederick3@indiegogo.com', 'f2691563-173b-522f-8a25-599c1fcc7772', '757538186', '{bcrypt}$2a$10$dv0CLXH26HwzBgslsSY6K.IZzQSuqPUzLGE/CzuyzUM8EqJLyq/tm', 'default.jpeg', false, true, true, true, true, '2023-01-29', '2022-04-15', 'USER', false, 11, 64); --K75UZOdc.
insert into user_entity (full_name, user_name, email, id, phone_number, password, img_path, verified, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at, roles, authorized, city, gender) values ('Goldia Sturley', 'gsturley4', 'gsturley4@sogou.com', '65d4b372-12b6-5167-8d2c-1b797fdf3b74', '536914860', '{bcrypt}$2a$10$2D95SuKcSRktx5WyIXsGuupCXJXIsVftsSPTtgx0KkDHL8bHh7sYC', 'default.jpeg', false, true, true, true, true, '2022-07-18', '2022-09-02', 'USER', false, 9, 64); --9roQQv5to.
insert into user_entity (full_name, user_name, email, id, phone_number, password, img_path, verified, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at, roles, authorized, city, gender) values ('Melisse Gatiss', 'mgatiss5', 'mgatiss5@live.com', '9cc870e3-adb0-5e8e-ac2a-cfccf662f175', '889772243', '{bcrypt}$2a$10$iMMFtrWiVGlTiziXWQE4J.kcbRn8YneYc53VC8B68seerCljMicC.', 'default.jpeg', false, true, true, true, true, '2022-12-20', '2023-02-04', 'USER', false, 34, 65); --mZIeSiz.9
insert into user_entity (full_name, user_name, email, id, phone_number, password, img_path, verified, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at, roles, authorized, city, gender) values ('Carlie Scragg', 'cscragg6', 'cscragg6@redcross.org', 'd8f6dc83-b45a-5e24-9baa-18c29a9e6e50', '247910588', '{bcrypt}$2a$10$Q0GliOSQccmBKYfdHePiMutLSBJIzYczOcSZ1ZNSovDbP3Qr3BrGe', 'default.jpeg', false, true, true, true, true, '2022-10-28', '2022-03-14', 'USER', false, 2, 64); --9JYFWukND.
insert into user_entity (full_name, user_name, email, id, phone_number, password, img_path, verified, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at, roles, authorized, city, gender) values ('Jenda Frichley', 'jfrichley7', 'jfrichley7@apple.com', '62a17769-cc2b-5c2a-bc1a-9e76911e999b', '889574986', '{bcrypt}$2a$10$QhNubUOiyOgPVTI/oOgnLeM7nP4bPiCbLbpHzlDjqySTYx6AmNKuK', 'default.jpeg', false, true, true, true, true, '2022-11-07', '2022-06-18', 'USER', false, 48, 65); --KQHohyMe.1
insert into user_entity (full_name, user_name, email, id, phone_number, password, img_path, verified, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at, roles, authorized, city, gender) values ('Andi Stolz', 'astolz8', 'astolz8@epa.gov', 'e55c3744-0875-5044-bb2c-c9fd761af605', '602630465', '{bcrypt}$2a$10$84/WH4qo4DgulW3XzrcTduod0cOnUSiISYd0vgHrb5j5/IrgtGhi2', 'default.jpeg', false, true, true, true, true, '2022-10-17', '2022-08-29', 'USER', false, 35, 64); --I2twy6v.
insert into user_entity (full_name, user_name, email, id, phone_number, password, img_path, verified, account_non_expired, account_non_locked, credentials_non_expired, enabled, created_at, last_password_change_at, roles, authorized, city, gender) values ('Solomón García', 'ferxxo', 'ferxxo@gmail.com', '74002906-c609-5b6b-9acf-177f11e48261', '158878439', '{bcrypt}$2a$10$fep2rjFYeLmppZBXDWA1TuwRY0qpkrA2dKDH8eBB1.xOGUmfpbelm', 'default.jpeg', true, true, true, true, true, '2022-12-04', '2022-05-07', 'USER, VERIFIED', false, 44, 63); --Estuche39_

insert into post (id, affair, content, img_paths, post_date, user_who_post) values (53, 'VP Marketing', 'Shakira lo deja con Piqué y su triple M es “ más buena, más dura, más level”, yo lo dejo con alguien y la triple M es “Mcnuggets, Mcflurry, Maxibon”', 'VACIO', '2022-04-09', '74002906-c609-5b6b-9acf-177f11e48261');
insert into post (id, affair, content, img_paths, post_date, user_who_post) values (54, 'Engineer I', 'Son nuestros grandes referentes y el espejo en el que nos miramos cada día. Gracias por ser nuestro mejor ejemplo. ', 'VACIO', '2022-05-13', 'd8f6dc83-b45a-5e24-9baa-18c29a9e6e50');
insert into post (id, affair, content, img_paths, post_date, user_who_post) values (55, 'Engineer I', '“En una práctica, Messi fue derribado y el DT no le dio el tiro libre. Enojado, a la jugada siguiente pidió la pelota, arrancó en su área, gambeteó a Touré, Puyol, Iniesta, Xavi y Busquets. Y metió el gol. Ahí me di cuenta que era mejor que el resto”.', 'VACIO', '2022-09-21', '8ee56ea7-ce36-595c-bfb4-b5fd87e34b09');
insert into post (id, affair, content, img_paths, post_date, user_who_post) values (56, 'Geologist I', 'Selena Gomez comentó en un TikTok donde Hailey Bieber puso cara de disgusto al escuchar el nombre de Taylor Swift ', 'VACIO', '2022-06-21', 'd8f6dc83-b45a-5e24-9baa-18c29a9e6e50');
insert into post (id, affair, content, img_paths, post_date, user_who_post) values (57, 'Marketing Manager', 'Dejaré las redes sociales. Tengo todo el derecho de defender a mis amigos. Digan lo que quieran sobre mí, pero moriría por mis amigos. Muchas gracias.', 'VACIO', '2023-01-17', '74002906-c609-5b6b-9acf-177f11e48261');
insert into post (id, affair, content, img_paths, post_date, user_who_post) values (58, 'Safety Technician I', 'se puede ser tan mala leche???', 'VACIO', '2022-02-26', '74002906-c609-5b6b-9acf-177f11e48261');
insert into post (id, affair, content, img_paths, post_date, user_who_post) values (59, 'Senior Developer', 'yo viendo que el outfit que tenía pensando no me queda bien', 'VACIO', '2023-01-12', '8ee56ea7-ce36-595c-bfb4-b5fd87e34b09');
insert into post (id, affair, content, img_paths, post_date, user_who_post) values (60, 'Structural Engineer', 'Siempre me lia y no es Sikora', 'VACIO', '2022-05-06', '8ee56ea7-ce36-595c-bfb4-b5fd87e34b09');
insert into post (id, affair, content, img_paths, post_date, user_who_post) values (61, 'Accounting Assistant III', 'acabo de ver un tiktok donde una piba dice q usa su misma ropa interior varios dias cuando esta menstruando pq con las toallitas no se le ensucia la bombacha', 'VACIO', '2023-01-10', '8ee56ea7-ce36-595c-bfb4-b5fd87e34b09');
insert into post (id, affair, content, img_paths, post_date, user_who_post) values (62, 'Research Associate', 'Hoy se viene un unboxing masivo de todas las mierdas que me he comprado en Japon y cosas chulas que me han enviado mientras estaba fuera 📦📦📦', 'VACIO', '2022-11-01', '1de440c9-6c02-5d77-8586-bc6a7ad216ed');

insert into event (dtype, id, name, city, location, capacity, type, popularity, img_path) values ('Discotheque', 66, 'Dablist', 1, '20.1591959/-100.5064114', 786, 'DISCOTHEQUE', 0, 'default-events.png');
insert into event (dtype, id, name, city, location, capacity, type, popularity, img_path) values ('Discotheque', 67, 'Browsezoom', 2, '28.0547578/81.614468', 1271, 'DISCOTHEQUE', 0, 'default-events.png');
insert into event (dtype, id, name, city, location, capacity, type, popularity, img_path) values ('Discotheque', 68, 'Yotz', 3, '12.87678/44.99309', 1184, 'DISCOTHEQUE', 0, 'default-events.png');
insert into event (dtype, id, name, city, location, capacity, type, popularity, img_path) values ('Discotheque', 69, 'Vidoo', 4, '48.911035/2.16555', 1061, 'DISCOTHEQUE', 0, 'default-events.png');
insert into event (dtype, id, name, city, location, capacity, type, popularity, img_path) values ('Discotheque', 70, 'Devbug', 5, '41.4575762/-8.5717827', 1140, 'DISCOTHEQUE', 0, 'default-events.png');
insert into event (dtype, id, name, location, city, capacity, date_time, duration, price, drink_included, number_of_drinks, adult, type, popularity, img_path) values ('Festival', 71, 'Fatz', '-16.4359692/-71.6050339', 6, 10000, '2023-06-13', 3, 112, false, 0, false, 'FESTIVAL', 0, 'default-events.png');
insert into event (dtype, id, name, location, city, capacity, date_time, duration, price, drink_included, number_of_drinks, adult, type, popularity, img_path) values ('Festival', 72, 'LiveZ', '50.2124156/36.1590565', 7, 14000, '2023-08-01', 3, 21, false, 0, true, 'FESTIVAL', 0, 'default-events.png');
insert into event (dtype, id, name, location, city, capacity, date_time, duration, price, drink_included, number_of_drinks, adult, type, popularity, img_path) values ('Festival', 73, 'Camimbo', '22.672099/113.250897', 8, 12200, '2023-08-24', 1, 5, true, 4, true, 'FESTIVAL', 0, 'default-events.png');
insert into event (dtype, id, name, location, city, capacity, date_time, duration, price, drink_included, number_of_drinks, adult, type, popularity, img_path) values ('Festival', 74, 'Ntag', '19.7633057/96.0785104', 9, 11200, '2023-07-01', 5, 76, true, 4, false, 'FESTIVAL', 0, 'default-events.png');
insert into event (dtype, id, name, location, city, capacity, date_time, duration, price, drink_included, number_of_drinks, adult, type, popularity, img_path) values ('Festival', 75, 'Rhyloo', '41.44056/22.72778', 10, 5000, '2023-07-05', 3, 148, true, 2, false, 'FESTIVAL', 0, 'default-events.png');

insert into likedPosts (user_id, post_id) values ('74002906-c609-5b6b-9acf-177f11e48261', 60);
insert into likedPosts (user_id, post_id) values ('62a17769-cc2b-5c2a-bc1a-9e76911e999b', 53);
insert into likedPosts (user_id, post_id) values ('62a17769-cc2b-5c2a-bc1a-9e76911e999b', 58);
insert into likedPosts (user_id, post_id) values ('1de440c9-6c02-5d77-8586-bc6a7ad216ed', 62);

insert into userfollows (user_who_is_followed_id, user_who_follows_id) values ('74002906-c609-5b6b-9acf-177f11e48261', '62a17769-cc2b-5c2a-bc1a-9e76911e999b');
insert into userfollows (user_who_is_followed_id, user_who_follows_id) values ('74002906-c609-5b6b-9acf-177f11e48261', '1de440c9-6c02-5d77-8586-bc6a7ad216ed');
insert into userfollows (user_who_is_followed_id, user_who_follows_id) values ('74002906-c609-5b6b-9acf-177f11e48261', 'f2691563-173b-522f-8a25-599c1fcc7772');
insert into userfollows (user_who_is_followed_id, user_who_follows_id) values ('74002906-c609-5b6b-9acf-177f11e48261', 'e55c3744-0875-5044-bb2c-c9fd761af605');
insert into userfollows (user_who_is_followed_id, user_who_follows_id) values ('74002906-c609-5b6b-9acf-177f11e48261', '8ee56ea7-ce36-595c-bfb4-b5fd87e34b09');
insert into userfollows (user_who_is_followed_id, user_who_follows_id) values ('74002906-c609-5b6b-9acf-177f11e48261', 'df442a4d-2ec0-54b6-ab24-019787533d25');

alter sequence hibernate_sequence restart with 76