#!/usr/bin/env ruby
require 'gosu'

height = 600
width = 900

class MyWindow < Gosu::Window
  def initialize
   super(900, 600, false)
   self.caption = 'play xl'
   @font = Gosu::Font.new(self, Gosu::default_font_name, 100)
   @gameover = false

   #change name
   self.reset
 end
 def reset
   @background_image = Gosu::Image.new(self, "pictures/tie_fighter_by_acidictaco.png", true)
   @player = Player.new(self)
   @player.warp(200, 300)
   @gun = Gun.new(self)
   @gun.place(500,340)
   @gunshot = Gosu::Sample.new(self, "bang.wav")
   @has_gun = false
   @score=0
   @scoreboard = Gosu::Font.new(self,  Gosu::default_font_name, 20)
   @scoreboard.draw(@score, 20, 20, 100, 1.0, 1.0, 0xffffff00)
   @bullet = Bullet.new(self)

 end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn_right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.accelerate
    end
    if button_down? Gosu::KbSpace then
      puts @player.morescore
    end
    if button_down? Gosu::KbQ then
      self.close
    end
    if button_down? Gosu::KbR then
      @gameover=false
      @player = Player.new(self)
      @player.warp(320, 240)
      @gun = Gun.new(self)
      @gun.place(500,340)
    end
    if button_down? Gosu::KbBackspace then
      if @has_gun == true
        x = @player.x + 100
        y = @player.y + 100
        @gunshot.play(0.1, 1)
        @bullet.shoot(x,y, 10, @player.angle + 45 )
      end
    end
    if button_down? Gosu::KbT then
      #print @player.x, @player.y
    end

    @player.move
    @bullet.move


    if @player.collides? @gun
      @has_gun = true
      @player.image = Gosu::Image.new(self, "pictures/madman2.png", false)
      @gun = Gun.new(self)
    end

    if @player.collides? @bullet
      @gameover=true

      self.reset


    end






  end


  def draw
    @background_image.draw(0, 0, 0)

    if @gameover==true
      @font.draw("game over", 300, 10, 1.0, 1.0, 1.0)
    end


    @player.draw
    @gun.draw
    @bullet.draw


  end




end


class Player
  attr_accessor :speed, :x, :y, :radius, :image, :angle

  def initialize(window)
    @image = Gosu::Image.new(window, "pictures/madman3.png", false)
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
    @radius = 100

  end


  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 600
    @y %= 900

    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def morescore
    @score += 100
    return @score
  end


  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def collides?(thing2)
    dist = Gosu::distance(@x, @y, thing2.x, thing2.y)
    dist < (@radius + thing2.radius)
  end

end

class DiamondBlock
  def initialize(window)
    @image = Gosu::Image.new(window, "pictures/spt.png", false)
    @x = @y = @vel_x = @vel_y = @angle = 0.0
  end

  def place(x, y)
    @x, @y = x, y
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5,  0.2,0.2)
  end
end

class Gun
  attr_accessor :speed, :x, :y, :radius, :bullet
  def initialize(window)
    @image = Gosu::Image.new(window, "pictures/gun.png", false)
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @radius = 50
    @x = @y = -100
  end


  def place(x, y)
    @x, @y = x, y
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5,  0.2,0.2)
  end
end


class Bullet
  attr_accessor :speed, :x, :y, :radius
  def initialize(window)
    @image = Gosu::Image.new(window, "pictures/bullet3.png", false)
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @radius = 10
    @x = @y = -100
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 600
    @y %= 900


  end



  def shoot(x, y, speed, angle)
    @x, @y = x, y
    @vel_x = speed
    @vel_y = speed
    @angle = angle

  end

  def draw
    @image.draw_rot(@x, @y, 0, @angle, 0.5, 0.5,  0.2,0.2)
  end
end


def reset
  window = MyWindow.new
  window.show
end

reset
