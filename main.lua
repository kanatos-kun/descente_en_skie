-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

-- Module 
require ('util')
-- Global

-- List
layer = {}
map = {}
objet = {}
list_collision= {}
data = { score = 0}
-- Local
local imgHero = {(love.graphics.newImage("image/skieur.png")),
                 (love.graphics.newImage("image/skieur_frein.png"))}
local imgTile = {(love.graphics.newImage("image/neige.png")),
                 (love.graphics.newImage("image/sapin.png"))}
local imgMenu     = love.graphics.newImage("image/menu.png")
local imgGameOver = love.graphics.newImage("image/game_over.png")
local ligne, colonne
local genSapin = 15
local score = 0
local vy = 0
local limitY = 0
local tileMove = false
local counter = 0
local chrono = 1
local vitesseY = 0.2

local menu_courant = "menu"
math.randomseed(love.timer.getTime())

function love.load()
  initMap()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  playerInitialize()
  generationSapin()
    
      for ligne = 0,(#layer[2]-1) do
    for colonne = 0,(#layer[2][ligne+1]-1) do
      local tile = layer[2][ligne+1][colonne+1]
        if tile == "sapin" then
          collisionInitialize(imgTile[2],colonne*8,ligne*8)
        end
    end
  end
end

function resetGame()
text = ""
score = 0
vy = 0
limitY = 0
tileMove = false
counter = 0
chrono = 1
genSapin = 15
vitesseY = 0.2
data.send = false
layer = {}
map = {}
objet = {}
list_collision= {}
playerInitialize()
initMap()
end

function playerInitialize()
player   = {}
player.image = {imgHero[1],imgHero[2]}
player.x = 8*10
player.y = 20
player.w = player.image[1]:getWidth()
player.h = player.image[1]:getHeight()
player.colY = 4
player.colX = 4
end

function collisionInitialize(pImg,pX,pY)
collision = {}
collision.image = pImg
collision.x = pX
collision.y = pY-vy
collision.w = pImg:getWidth()
collision.h = pImg:getHeight()
collision.colY = 4
collision.colX = 4
table.insert(list_collision,collision)
end

function initMap()
table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --01
table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --02
table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --03
table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --04
table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --05
table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --06
table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --07
table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --08
table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --09
table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --10
table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --11
table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --12
table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --13
table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --14
table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --15
table.insert(layer,map)

table.insert(objet,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --01
table.insert(objet,{0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0}) --02
table.insert(objet,{1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,0,1}) --03
table.insert(objet,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --04
table.insert(objet,{1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,0,1}) --05
table.insert(objet,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --06
table.insert(objet,{1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,0,1}) --07
table.insert(objet,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --08
table.insert(objet,{1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,0,1}) --09
table.insert(objet,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --10
table.insert(objet,{1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,0,1}) --11
table.insert(objet,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --12
table.insert(objet,{1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,0,1}) --13
table.insert(objet,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --14
table.insert(objet,{1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,0,1}) --15
table.insert(layer,objet)
end

function generationSapin()
  for ligne =0,(#layer[2]-1) do
    for colonne =0,(#layer[2][ligne+1]-1) do
      local tile = layer[2][ligne+1][colonne+1]
        if tile == 1 then
          if math.random(genSapin) == 1 then
           layer[2][ligne+1][colonne+1] = "sapin"
           collisionInitialize(imgTile[2],colonne*8,ligne*8)
          elseif math.random(genSapin)~= 1 then
           layer[2][ligne+1][colonne+1] = 0
          end
        end
    end
  end
end

function updateJeu(dt)

  if tileMove then vy = vy + vitesseY 
                   limitY = limitY + vitesseY
                   chrono = chrono + 1 end

if chrono >= 100 then score = score + 100 chrono = 0 end

local ancienX = player.x

if love.keyboard.isDown("q") then
player.x = player.x - 50*dt
if player.x < 0 then player.x = ancienX end
end

if love.keyboard.isDown("d") then
player.x = player.x + 50*dt
if player.x > largeur/5 - player.w then player.x = ancienX  end
end

for col = #list_collision,1,-1 do
  local sapin = list_collision[col]
  if tileMove then
  sapin.y = sapin.y - vitesseY
  end
  if collide(player,sapin) then 
    menu_courant ="gameOver"
  end
  if (sapin.y-vitesseY)+sapin.w < 0 then
    table.remove(list_collision,col)
  end
end

-- timer generation de nouveaux sapin
if limitY >= 5 then
      table.insert(map,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --xx
      table.insert(layer,map)
      if counter == 0 then
      table.insert(objet,{1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,0,1}) --xx
      table.insert(layer,objet)
      generationSapin()
      counter = 1
      elseif counter == 1 then
      table.insert(objet,{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}) --xx
      table.insert(layer,objet)
      counter = 2
      elseif counter == 2 then
      table.insert(objet,{1,0,0,0,1,1,0,1,1,1,1,1,0,0,0,1,1,0,0,0}) --xx
      table.insert(layer,objet)
      generationSapin()
      counter = 0      
      end
limitY = 0
end

if score == 500 then
vitesseY = 0.6
elseif score == 1000 then
vitesseY = 0.8
elseif score == 1500 then
vitesseY = 1
elseif score == 2000 then
genSapin = 12
elseif score == 2500 then
genSapin = 8
elseif score == 3000 then
vitesseY = 1.2
elseif score == 3500 then
genSapin = 7
elseif score == 3800 then
vitesseY = 1.3
elseif score == 3900 then
genSapin = 6
elseif score == 4000 then
vitesseY = 1.4
elseif score == 4100 then
vitesseY = 1.5
elseif score == 4200 then
genSapin = 5
elseif score == 4300 then
vitesseY = 1.6
elseif score == 4400 then
genSapin = 4
elseif score == 4500 then
vitesseY = 1.7
elseif score == 4600 then
genSapin = 3
elseif score == 4700 then
vitesseY = 1.8
elseif score == 4800 then
vitesseY = 1.9
end   
end

function updateMenu(dt)
end

function updateGameOver(dt)
  data.score = score
end

function love.update(dt)
  if menu_courant == "menu" then
    updateMenu(dt)
  elseif menu_courant == "jeu" then
    updateJeu(dt)
  elseif menu_courant == "gameOver" then
    updateGameOver(dt)
  end
end

function drawJeu()
love.graphics.scale( 5 )
  for ligne = 0,(#layer[1]-1) do
    for colonne = 0,(#layer[1][ligne+1]-1) do
      local tile = layer[1][ligne+1][colonne+1]
        if tile == 0 then
          love.graphics.draw(imgTile[tile+1],colonne*8,ligne*8)
        end
    end
  end

love.graphics.draw(player.image[1],player.x,player.y,0,1,1,player.w/2,player.h/2)
for n = 1,#list_collision do
local s = list_collision[n]
love.graphics.draw(s.image,s.x,s.y,0,1,1,s.w/2,s.h/2)
end

love.graphics.setColor(0,0,0)
love.graphics.print("Score : "..score,(largeur/2/5)-10,0,0,0.2,0.2)
if not tileMove then
love.graphics.print("Press [Any touch] for play ",(largeur/2/5)-10,(hauteur/2/5),0,0.2,0.2)
end
love.graphics.setColor(255,255,255)

end

function drawMenu()
love.graphics.scale( 5 )
love.graphics.draw(imgMenu,0,0)
end

function drawGameOver()
love.graphics.scale( 5 )
love.graphics.draw(imgGameOver,0,0)
love.graphics.setColor(255,255,255)
love.graphics.print("score : "..data.score,(largeur/2/5)-10,(hauteur/2/5)+10,0,0.5,0.5)
end

function love.draw()
if menu_courant == "menu" then
  drawMenu()
elseif menu_courant =="jeu" then
  drawJeu()
elseif menu_courant == "gameOver" then
  drawGameOver()
end
end

function love.keypressed(key)
 if menu_courant == "menu" then
   if key == "return" then
     menu_courant = "jeu"
   end
   
   elseif menu_courant == "jeu" then
      if key == "return" or "q" or "d" then
        tileMove = true
      end
    elseif menu_courant == "gameOver" then
      if key == "return" then
      resetGame()
      menu_courant = "menu"
      end
  end
end
  