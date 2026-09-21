/*!
 *  OpenSCAD 2021.01
 *    Library:    case.scad
 *    Author:     Hotabich
 *    Copyright:  © Hotabich, 2025
 *
 *
 *  MODULES:
 *    topCase(size, thickness, radius, center=true/false, sideonly=true/false);
 *      Верхня частина корпусу
 *        size      : Розміри корпусу.
 *                      x / [x, y, z].
 *        thickness : Товщина стінки корпусу.
 *        radius    : Радіус скруглення кутів.
 *        center    : Розміщення корпусу в просторі.
 *                    За замовчуванням false.
 *                      true  - В центрі.
 *                      false - З початку координат.
 *        sideonly  : Де робити скруглення кутів.
 *                    За замовчуванням false.
 *                      true  - Скруглення тільки на одній частині корпусу.
 *                      false - Скруглення на всіх ребрах корпусу.
 *    
 *    bottomCase(size, thickness, radius, center=true/false, sideonly=true/false);
 *      Нижня частина корпусу
 *        size      : Розміри корпусу.
 *                      x / [x, y, z].
 *        thickness : Товщина стінки корпусу.
 *        radius    : Радіус скруглення кутів.
 *        center    : Розміщення корпусу в просторі.
 *                    За замовчуванням false.
 *                      true  - В центрі.
 *                      false - З початку координат.
 *        sideonly  : Де робити скруглення кутів.
 *                    За замовчуванням false.
 *                      true  - Скруглення тільки на одній частині корпусу.
 *                      false - Скруглення на всіх ребрах корпусу.
 *
 *    fastening(length, height, thickness, diameter, rounding=0.4, side=0/-1/1);
 *      Вушко кріплення.
 *        length   : Длинна вушка.
 *        height   : Висота вушка.
 *        thickness: Товщина стінок.
 *        diameter : Діаметр гвинта кріплення.
 *        rounding : Радіус скруглення кутів вушка біля корпусу.
 *                   За замовченням дорівнює 0.4.
 *                     0 - скруглення відсутьні.
 *        side     : Бік з якої распологається отвір під головку гвинта кріплення.
 *                   За замовчуванням дорівнює 0.
 *                     -1 - Отвір разпологається знизу.
 *                      1 - Отвір разпологається зверху.
 *                      0 - Отвір під головку відсутьній.
 *    
 *    ventilation(width, height, length, angle=39, way=0/-1/1);
 *      Отвори для вентиляції
 *        width   : Ширина отвору.
 *        height  : Висота отвору.
 *        length  : Довжина отвору
 *        angle   : Угол повороту отворів.
 *        way     : Напрямок отворів.
 *                  За замовчуванням дорівнює 0.
 *                    -1 - Зліва направо.
 *                     1 - Справа наліво.
 *                     0 - Прямий отвір.
 *    
 *    platform(size, diameter, number_screws, holes_side=0/-1/1, center=true/false);
 *      Плоска основа
 *        size          : Розміри основи.
 *                          x / [x, y, z].
 *        diameter      : Діаметр гвинта кріплення.
 *        number_screws : Кількість гвинтів кріплення.
 *                          2 / 4.
 *        holes_side    : Сторона по якій знаходятся гвинти кріплення.
 *                        За замовчуванням дорівнює 0.
 *                          -1 - Отвори знаходяться по длинной стороні.
 *                           1 - Отвори знаходяться по короткой стороні.
 *                           0 - Отвори відсутні.
 *        center        : Розміщення основи в просторі.
 *                        За замовчуванням false.
 *                          true  - В центрі.
 *                          false - З початку координат.=true/false
 *
 *  EXAMPLE USAGE:
 *    topCase(size, thickness, radius, center=true, sideonly=true);
 *    bottomCase(size, thickness, radius, center=true, sideonly=false);
 *    fastening(length, height, thickness, diameter, rounding=0.4, side=0);
 *    ventilation(width, height, length, angle=39, way=-1);
 *    platform(size, diameter, number_screws, holes_side=1, center=false);
 */
//
include <GOST/nuts_and_bolts.scad>;

function sizeBox(size) = is_list(size) ? size : [size, size, size];
function sizeCuttingBox(size, thickness) = [size[0]-thickness*2, size[1]-thickness*2, size[2]-thickness];
function boxBendingRadius(radius) = is_num(radius) ? radius : 0.4;
function course(var) = (var < 0) ? -1 : (var > 0) ? 1 : 0;

module _body(size, r, sideonly)
/*  Службовий модуль побудови куба
      size     : Розміри корпусу.
                   [x, y, z].
      r        : Радіус скруглення кутів.
      sideonly : Де робити скруглення кутів.
                   true  - скруглення тільки на одній частині корпусу
                   false - скруглення на всіх ребрах корпусу
*/
{
  if (sideonly) {
    hull() {
      cube(size=[size[0], size[1], size[2] - r], center=false);
      hull() {
        translate(v=[r, r, size[2]-r]) sphere(r=r);
        translate(v=[size[0]-r, r, size[2]-r]) sphere(r=r);
        translate(v=[r, size[1]-r, size[2]-r]) sphere(r=r);
        translate(v=[size[0]-r, size[1]-r, size[2]-r]) sphere(r=r);
      }
    }
  } else {
    hull() {
      translate(v=[r, r, 0]) cylinder(h=size[2]-r, r=r, center=false);
      translate(v=[size[0]-r, r, 0]) cylinder(h=size[2]-r, r=r, center=false);
      translate(v=[r, size[1]-r, 0]) cylinder(h=size[2]-r, r=r, center=false);
      translate(v=[size[0]-r, size[1]-r, 0]) cylinder(h=size[2]-r, r=r, center=false);
      translate(v=[r, r, size[2]-r]) sphere(r=r);
      translate(v=[size[0]-r, r, size[2]-r]) sphere(r=r);
      translate(v=[r, size[1]-r, size[2]-r]) sphere(r=r);
      translate(v=[size[0]-r, size[1]-r, size[2]-r]) sphere(r=r);
    }
  }
}
//
module _case(size, thickness, radius, sideonly)
/*  Службовий модуль побудови корпусу
      size      : Розміри корпусу.
//                  x / [x, y, z].
      thickness : Товщина стінки корпусу.
      radius    : Радіус скруглення кутів.
      sideonly  : Де робити скруглення кутів.
                  За замовчуванням false.
                    true  - Скруглення тільки на одній частині корпусу.
                    false - Скруглення на всіх ребрах корпусу.
*/
{
  difference() {
    _body(size=size, r=boxBendingRadius(radius), sideonly=sideonly);
    translate(v=[thickness, thickness, -0.01]) {
      _body(size=sizeCuttingBox(size, thickness), r=boxBendingRadius(radius), sideonly=sideonly);
    }
  }
}
//
module topCase(size, thickness, radius, center=false, sideonly=false)
/*  Верхня частина корпусу
      size      : Розміри корпусу.
                    x / [x, y, z].
      thickness : Товщина стінки корпусу.
      radius    : Радіус скруглення кутів.
      center    : Розміщення корпусу в просторі.
                  За замовчуванням false.
                    true  - В центрі.
                    false - З початку координат.
      sideonly  : Де робити скруглення кутів.
                  За замовчуванням false.
                    true  - Скруглення тільки на одній частині корпусу.
                    false - Скруглення на всіх ребрах корпусу.
*/
{
  s = sizeBox(size);

  translate(center ? -s/2 : [0, 0, 0]) {
    _case(size=s, thickness=thickness, radius=boxBendingRadius(radius), sideonly=sideonly);
  }
}
//
module bottomCase(size, thickness, radius, center=false, sideonly=false)
/*  Нижня частина корпусу
      size      : Розміри корпусу.
                    x / [x, y, z].
      thickness : Товщина стінки корпусу.
      radius    : Радіус скруглення кутів.
      center    : Розміщення корпусу в просторі.
                  За замовчуванням false.
                    true  - В центрі.
                    false - З початку координат.
      sideonly  : Де робити скруглення кутів.
                  За замовчуванням false.
                    true  - Скруглення тільки на одній частині корпусу.
                    false - Скруглення на всіх ребрах корпусу.
*/
{
  s = sizeBox(size);

  translate(center ? -s/2 : [0, 0, 0]) mirror(v=[0, 0, 1]) translate(v=[0, 0, -s[2]]) {
    _case(size=s, thickness=thickness, radius=boxBendingRadius(radius), sideonly=sideonly);
  }
}
//
module fastening(length, height, thickness, diameter, rounding=0.4, side=0)
/*  Вушко кріплення.
      length   : Длинна вушка.
      height   : Висота вушка.
      thickness: Товщина стінок.
      diameter : Діаметр гвинта кріплення.
      rounding : Радіус скруглення кутів вушка біля корпусу.
                 За замовченням дорівнює 0.4.
                   0 - скруглення відсутьні.
      side     : Бік з якої распологається отвір під головку гвинта кріплення.
                 За замовчуванням дорівнює 0.
                   -1 - Отвір разпологається знизу.
                    1 - Отвір разпологається зверху.
                    0 - Отвір під головку відсутьній.
*/
{
  width = diameter+0.2+thickness*2; // ширина вушка
  yaxis = (width < length) ? length-width/2 : width/2-0.05; // зміщення для встановлення довжини
  side = (height-diameter)/2*side; // положення виборки під коловку гвинта
  
  translate(v=[0, (width > length) ? 0 : (length-width)/2, 0]) { // центруємо вушко кріплення
    difference() {
      union() { // вушко кріплення
        hull() { // тіло вушка кріплення
          cylinder(h=height, d=width, center=true);
          translate(v=[0, -yaxis, 0]) cube(size=[width, 0.1, height], center = true);
        }
        for (i = [0, 1]) { // скруглення кутів вушок біля корпусу
          mirror(v=[i, 0, 0]) translate(v=[(width+rounding)/2-0.01, -(yaxis-rounding/2+0.05), 0]) {
            difference() {
              cube(size=[rounding, rounding, height], center=true);
              translate(v=[rounding/2, rounding/2, 0]) cylinder(h=height+0.01, r=rounding, center=true);
            }
          }
        }
      }
      union() { // виріз під гвинт
        cylinder(h=height+0.01, d=diameter+0.5, center=true);
        if (side!=0) translate(v=[0, 0, side]) { // виріз під головку гвинта
          cylinder(h=diameter+0.01, r=METRIC_BOLT_CAP_DIAMETERS[diameter]/2+0.5, center=true);
        }
      }
    }
  }
}
//
module ventilation(width, height, length, angle=39, way=0)
/*  Отвори для вентиляції
      width   : Ширина отвору.
      height  : Висота отвору.
      length  : Довжина отвору
      angle   : Угол повороту отворів.
      way     : Напрямок отворів.
                За замовчуванням дорівнює 0.
                  -1 - Зліва направо.
                   1 - Справа наліво.
                   0 - Прямий отвір.
*/
{
  // напрямок отвору
  way = course(way);
  // координати точки по осях
  xaxes = height/sin(angle)*cos(angle)*way;
  yaxes = height/sin(angle)*sin(angle);
  // зсув для центрування по осях 
  xoffset = (width+xaxes)/2;
  yoffset = yaxes/2;
  // форма отвора вентиляції
  dot=[
    [0-xoffset, 0-yoffset],
    [width-xoffset, 0-yoffset],
    [width+xaxes-xoffset, yaxes-yoffset],
    [xaxes-xoffset, yaxes-yoffset]
  ];
  
  linear_extrude(height=length, center=true) polygon(dot);
}
//
module platform(size, diameter, number_screws, holes_side=0, center=false)
/*  Плоска основа
      size          : Розміри основи.
                        x / [x, y, z].
      diameter      : Діаметр гвинта кріплення.
      number_screws : Кількість гвинтів кріплення.
                        2 / 4.
      holes_side    : Сторона по якій знаходятся гвинти кріплення.
                      За замовчуванням дорівнює 0.
                        -1 - Отвори знаходяться по длинной стороні.
                         1 - Отвори знаходяться по короткой стороні.
                         0 - Отвори відсутні.
      center        : Розміщення основи в просторі.
                      За замовчуванням false.
                        true  - В центрі.
                        false - З початку координат.=true/false
*/
{
  s = sizeBox(size);
  holes_side = course(holes_side);
  number_screws = (number_screws == 2) ? 2 : (number_screws == 4) ? 4 : 0;
  
  translate(center ?  [0, 0, 0] : s/2) {
    difference() {
      cube(size=s, center=true); // основа платформи
      union() { // отвори під гвинти
        if (holes_side!=0) {
          // зміщення для отворів по осях
          xaxis = s[0]/2-diameter;
          yaxis = s[1]/2-diameter;
          if (number_screws == 2) { // 2 отвори на сторону
            if (holes_side > 0) { // отвори знаходяться по короткой стороні
              if (s[0] < s[1]) { // коротка сторона по осі X
                for (y=[-yaxis, yaxis]) {
                  translate(v=[0, y, 0]) cylinder(h=s[2]+0.01, d=diameter, center=true);
                }
              } else if (s[0] > s[1]) { // коротка сторона по осі Y
                  for (x=[-xaxis, xaxis]) {
                    translate(v=[x, 0, 0]) cylinder(h=s[2]+0.01, d=diameter, center=true);
                  }
                }
            } else if (holes_side < 0) { // отвори знаходяться по длинной стороні
              if (s[0] > s[1]) { // довга сторона осі X
                for (y=[-yaxis, yaxis]) {
                  translate(v=[0, y, 0]) cylinder(h=s[2]+0.01, d=diameter, center=true);
                }
              } else if (s[0] < s[1]) { // довга сторона осі Y
                  for (x=[-xaxis, xaxis]) {
                    translate(v=[x, 0, 0]) cylinder(h=s[2]+0.01, d=diameter, center=true);
                  }
                }
            }
          } else if (number_screws == 4){ // 4 отвори на сторону
            for (x=[-xaxis, xaxis], y=[-yaxis, yaxis]) {
              translate(v=[x, y, 0]) cylinder(h=s[2]+0.01, d=diameter, center=true);
            }
          }
        }
      }
    }
  }
}