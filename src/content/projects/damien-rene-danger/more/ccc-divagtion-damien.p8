pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
size={h=127,w=127}

ct=0

lki=24
lkj=31
initl=0
load_over=false
lf=0

--[[
--no audio save token
--
function story_sfx(id,t)
 
 local s={
  id=id,
  loop=0,
  t=t,
  
  update = function(self) 	
   if stat(49)<0
   then
    if self.loop<self.t
    then
     sfx(self.id,3)
     self.loop+=1
     return false
    else
     return true--sfx ended
    end
   else
    return false
   end--something playing
  end,
  
  draw= function(self)
  end,  
 }
 return s
end
--]]

function story_h_bar(f,t,m)
 
 local s =
  {
   j=f,
   m=m,
   t=t,
   fx=true,
   
   update = function(self)
    self.j+=self.m
    if self.m<0 then
     return self.j<=self.t
    else
     return self.j>=self.t
    end
   end,
   
   draw=function(self,i,j)
    line(0,self.j,127,self.j,14)
   end
  }
 
 return s

end

function story_counter(pre,c)
 local s= {
  tot=c,
  i=0,
  u=2,
  f=0,
  j=0,
  pre=pre,
  draw=function(self,i,j)
   local str = ""
   if self.j>=#self.pre then
    str= self.pre.." "
    ..self.i.."/"..self.tot
   else
    str = sub(self.pre,0,
     self.j)
   end
   
   print(str,i,j,12)
  end,
  
  update=function(self)
   if self.j < #self.pre
   then
    self.f+=1
    if self.f == self.u then
     self.f=0
     self.j+=1
     --no audio save token
     --sfx(1,2)
    end    
   else
    self.i+=flr(rnd(200))
    if self.i >= self.tot then
     self.i=self.tot
    return true
    else
     return false
    end 
   end      
  end--update
 }
 return s
end

function story_txt(txt,w,sym,col)
 if col == nil then
  col=6
 end
 
 local s = {
  t = txt,
  i = 0,
  w = w,
  j = 0,
  k = 0,
  u = 2,
  f = 0,
  sym=sym,
  truesize=0,
  col=col,
  update = function(self)
   self.truesize=#self.t
   self.f+=1
   if self.f>= self.u then
    self.f=0    
	   self.i+=1
	   if self.i>#self.t then
	    if self.j<self.w then
	     if self.k<3 then
	     self.t=self.t..sym
	     self.i+=1
	     self.k+=1
	     else
	     	self.t=
	     	 sub(self.t,0,#self.t-3)
	     	self.i=#self.t
	     	self.k=0
	      self.j+=1	      
	     end
	    else
	     return true
	    end --w,check
	   else
	    --no audio save token
	    --sfx(1,2)
	   end--i,t check
	   return false
	  else
	   return self.j>=self.w and
	   self.i>=#self.t
	  end--f<u
  end,--update
 
  draw = function(self,i,j)
   str = sub(self.t,0,self.i)
   print(str,i,j,col)
  end
 }
 
 return s
end--story txt

--[[
--no audio save token
--
radio={
 c1={},
 play = function(self,id,t)
  local s = 
  story_sfx(id,t)
  
  add(self.c1,s)
  s:update()  
 end,
 
 update = function(self)
  for s in all(self.c1) do
   if s:update() then
    del(self.c1, s)
   end 
  end
 end
}
--]]

console=
{
 i=1,
 truesize=64,
 truehigh=32,
 dwidth=64,
 dheight=32,
 t=
 {
  --no audio save token
  --story_sfx(6,2),
  story_txt(
   "cookie collective compilation" ,3, " "),

  story_txt(" ",0," "), 
  story_txt("> ls",3,".",11),
  story_h_bar(0,128,20),

  story_txt("./",0,""),
  story_txt("./divagation.p8",0,""),
  story_txt("./readme",3," "),
  story_txt(" ",0," "),
  
  story_txt("> load divagation.p8",3,".",11),

  story_h_bar(0,128,20),
  story_txt("divagation boot start",3,"."),
  story_counter(
  "loading token",8011),  
  story_txt("init conway grid",3,"."),
  story_h_bar(0,128,20)
 },
 
 update = function(self)
  if #self.t>0 then
   local ended= self.t[self.i]:update()
   if ended then  
    if self.t[self.i].fx then
     deli(self.t,self.i)
    else
     self.i+=1
    end
   end
   return self.i>#self.t 
  end
 end,
 
 draw = function(self)
  rectfill(0,0,
  self.truesize,
  self.truehigh,1)

  if #self.t>0 then
	 for i=1,self.i do
	  self.t[i]:draw(0,i*6)
	  if self.t[i].truesize
	  then
	   newsize=self.t[i].truesize*4
	   if self.truesize < newsize
	   then
	    self.truesize=newsize
	   end 
	   
	  end
	 end 
	 end
 end,
 
 clr = function(self)
  self.t = {}
  self.i = 1                  
  self.truesize=self.dwidth
  self.trueheight=self.dheight
 end,
 
 sadd = function(self,s)
  add(self.t,s)
 end
}

--cookie count
ck=0

function _init()
 srand(10)  
 printh("start", "log.txt",true)
  
 --bake tore
 trl=11
 trw={} 
 trh={}
 for i=0-trl,size.w+trl do   
  trw[i]=tore_w(i)
 end 
 for j=0-trl,size.h+trl do
  trh[j]=tore_h(j)
 end

 cr_cwy = cocreate(create_conway) 
 --poke(0x5f2c,3)
end

--update
function _update()
 if cr_cwy then
  if costatus(cr_cwy)!="dead"
  then coresume(cr_cwy) end
 end
 
 if console:update() then
  load_over = true  
 end
  
 if load_over then
  --no audio save token
  --music(0,0,1)
  _update = _update_conway 
  _draw = _draw_conway
  start_conway() 
 end
end
---------------
-- draw --  ***
---------------
function _draw()
 cls(1)
 console:draw()
end

function _timeline()

end







-->8
--conway gol
cwy_perf=1000--350--limit before yield
cwy_cor=nil--coroutine
cwy_f=0--frame
cwy_l=0
last_i=-1
cwy_z=false
cwy_o=16--skip top line
gdd={}--grid draw data
blklimit=23
blkage=7
gridbreak=false
glitch1=0
glitch2=0
glitch3=0
snakeblk=1
hideconsole=false
finalscreen = false

function _init_conway()
 --inter vertical ok
 vtl=list2d(size.w)
 --inter horizontal ok
 hzl=list2d(size.w)
 --temp block
 tblk=list2d(size.w)
 gblk={}
 
 --pixel that stay alive
 cwy_stable=list2d(size.w)
 
 minsafe=
  {h=cwy_o+1, w=1}
 
 maxsafe=
  {h=size.h-1, w=size.w-1}

 initpannel()  
end

function create_conway()
 --rnd grid
 g={} 
 r={0,1}

 for i=0,63 do
  g[i]={}
  for j=0,cwy_o do
   g[i][j]=0--bizare
  end
  
  for j=cwy_o,size.h do
   g[i][j]=rnd(r)
  end
 end
 
 yield()

 for i=64,size.w do
  g[i]={}
  for j=0,cwy_o do
   g[i][j]=0--bizare
  end
  
  for j=cwy_o,size.h do
   g[i][j]=rnd(r)
  end
 end
 
 yield()
 
 _init_conway()
end

function _update_conway()
 cwy_f+=1

 resume_cwy()
 
 if stat(1)>0.98 then
  printh(cwy_f.." update "..stat(1),"log.txt", false)
 end

 local ended = console:update()
 if ended and gridbreak and
  not hideconsole 
  and #gblk>0 then
   --start snake
   console:clr()
   snakemode=true
   glitch1=1
   hideconsole=true
   snake.dx = gblk[1].i
   snake.dy = gblk[1].j
   --no audio save token
   --music(5,0)
 elseif ended and gridbreak and #gblk==0
  and not finalscreen
  then
   finalscreen =true
   hideconsole=false
  
   console:sadd(
   story_txt("high score",2," "))
  
   console:sadd(
   story_txt("------",0,""))
   maxscore=ck+flr(rnd(100))
   cookies = {
    "cOOKIE cOLLECTIVE."
    ..getfkpoint(0),
    "pICO-8............"
    ..getfkpoint(1),
    "rEVISION 2024....."
    ..getfkpoint(0),
    "lIVE cODERS......."
    ..getfkpoint(1),
    "cHAIR DE pOULE...."
    ..getfkpoint(0)  
   }
   --no audio save token
   --music(-1,300)
   for friends in all(cookies)
   do
    console:sadd(
    story_txt(friends,0,"",14))
   end  
   
    console:sadd(
    story_txt("------",0,""))
    
    console:sadd(
    story_h_bar(0,128,20))
    
    console:sadd(
				story_txt("----------------------",
				0,"",14))
    
    console:sadd(
    story_h_bar(0,128,20))
    
    console:sadd(
    story_txt("",0,""))
    
    console:sadd(
    story_txt("gameover",5," "))
    
    console:sadd(
    story_txt("",0,""))
    console:sadd(
    story_txt("please",0,""))
    console:sadd(
    story_txt("enjoy cookie's ",0,"",14))
    console:sadd(
    story_txt("other",0,""))
    console:sadd(
    story_txt("divagation",9,"♥",14))

    console:sadd(
    story_txt("--dAMIEN;",0,"",13))
    console:sadd(
    story_txt("",5," "))
  elseif ended and finalscreen then
   cls(0)
   stop("divagation interupted after "..flr(time()).."♪.")
  end
 
 if snakemode then
  reach=false
  for mi=1,snake.speed do
   if not reach then
    reach=movesnake()
   end
  end
  if reach then
   if snakeblk<#gblk then
   gblk[snakeblk].ok=false
    addpoint(100,gblk[snakeblk].i
    ,gblk[snakeblk].j)
    --no audio save token
    --sfx(2,2)
    glitch3=8
    snakeblk+=1
    snake.dx = gblk[snakeblk].i
    snake.dy = gblk[snakeblk].j
    snake.gw=true
   elseif #gblk>0 then
    gblk={}
    hideconsole=false
    console:sadd(
     story_txt("glitch clean",
      1,"."))
     snake.dx=0
     snake.dy=0
    --no audio save token
    --music(0,0,0)                           
   end
  end
 end
 --for game/debug
 --[[
 if btnp(⬅️) then
  lki=trw[lki-1] 
  rando:move(-1) 
 end
 
 if btnp(➡️) then 
  lki=trw[lki+1]
  rando:move(1)
 end
 
 if btnp(⬆️) then
  lkj=trh[lkj-1]
 end

 if btnp(⬇️) then
 lkj=trh[lkj+1] 
 end 
 --]]
end

function _draw_conway()
 cls(12)
   
 if glitch1 > 0 then
  drawglitch1()
  glitch1-=1
 elseif glitch2 > 0 then
  drawglitch2()
  glitch2-=1
 elseif glitch3 > 0 then
  drawglitch3()
  glitch3-=1 
  if glitch3<=0 then
   pal(12,12)
   pal(0,0)
  end
 else
   drawnoglitch()
 end
 
 drawpoints()
 drawpannel()
 if gridbreak 
 and not hideconsole then
  cslw=64
  if console.truesize>cslw
  then
   cslw=console.truesize
  end
  cslh=64
  local newh = console.i*6
  if newh > cslh then
   cslh=newh
  end
  if cslh>console.truehigh
  then
   console.truehigh=cslh
  end
  
  console:draw()
 end
 --no audio save token
 --radio:update()
 
 --[[
 --debug code
 lkcol=3
 if(g[lki][lkj]&1)==1 then
  lkcol=11
 end 
 pset(lki,lkj,lkcol) 
 --]]
 
  if snakemode then
   drawsnake()
  end
 
 if stat(1) > 0.98 then
  printh(cwy_f.." draw "..stat(1),"log.txt", false)
 end
end

function drawnoglitch()
 local gm=24576+4*16*cwy_o
 memp = 4
 while gm>0 do
  poke4(gm, gdd[gm])  
  gm+=memp
 end
end

function drawglitch1()
 local gm=24576+4*16*cwy_o 
 while gm>0 do
  poke4(gm, gdd[gm])
  memp = flr(rnd(16))
  gm+=memp
 end
end

function drawglitch2()
 local gm=24576+4*16*cwy_o
 r={1,-1}
 memp = flr(glitch2/2)*rnd(r)

 while gm>0 do
  poke4(gm+memp, gdd[gm])
  gm+=4
 end
end

function drawglitch3()
 pal(12,7)
 pal(0,8)
 local gm=24576+4*16*cwy_o
 r={1,-1}
 memp = flr(glitch3/2)*rnd(r)

 local gcol={7,8}
 
 
 while gm>0 do
   local ncol=
   0x.0001*rnd(gcol)|
   0x.0010*rnd(gcol)|
   0x.0100*rnd(gcol)|
   0x.1000*rnd(gcol)|
   0x0001*rnd(gcol)|
   0x0010*rnd(gcol)|
   0x0100*rnd(gcol)|
   0x1000*rnd(gcol)|
 
  poke4(gm+memp, ncol)
  gm+=4
 end
end

function start_conway()
 sim_cwy = cocreate(sim_conway)
 console:clr()
 console:sadd(story_h_bar(127,0,-20))
end

function resume_cwy()
 if sim_cwy then
  if costatus(sim_cwy)!="dead"
  then coresume(sim_cwy) end 
 end 
end

function sim_conway()
-------------------------------
-- calculate simulation      --
------------------------------- 
 local i=0
 local j=cwy_o
 cwy_l+=1
 for i=minsafe.w,8 do
 for j=minsafe.h,maxsafe.h do
  getc(i,j,i-1,i+1,j-1,j+1)
 end end
 --yield()--calc cwy
 for i=9,17 do
 for j=minsafe.h,maxsafe.h do
  getc(i,j,i-1,i+1,j-1,j+1)
 end end
 yield()--calc cwy
 for i=18,26 do
 for j=minsafe.h,maxsafe.h do
  getc(i,j,i-1,i+1,j-1,j+1)
 end end
 --yield()--calc cwy
 for i=27,35 do
 for j=minsafe.h,maxsafe.h do
  getc(i,j,i-1,i+1,j-1,j+1)
 end end
 yield()--calc cwy
 for i=36,44 do
 for j=minsafe.h,maxsafe.h do
  getc(i,j,i-1,i+1,j-1,j+1)
 end end
 --yield()--calc cwy  
 for i=45,53 do
 for j=minsafe.h,maxsafe.h do
  getc(i,j,i-1,i+1,j-1,j+1)
 end end  
 yield()--calc cwy
 for i=54,62 do
 for j=minsafe.h,maxsafe.h do
  getc(i,j,i-1,i+1,j-1,j+1)
 end end
 --yield()--calc cwy
 for i=63,71 do
 for j=minsafe.h,maxsafe.h do
  getc(i,j,i-1,i+1,j-1,j+1)
 end end
 yield()--calc cwy 
 for i=72,80 do
 for j=minsafe.h,maxsafe.h do
  getc(i,j,i-1,i+1,j-1,j+1)
 end end 
 --yield()--calc cwy
 for i=81,89 do
 for j=minsafe.h,maxsafe.h do
  getc(i,j,i-1,i+1,j-1,j+1)
 end end
 yield()--calc cwy
 for i=90,98 do
 for j=minsafe.h,maxsafe.h do
  getc(i,j,i-1,i+1,j-1,j+1)
 end end 
 --yield()--calc cwy
 for i=99,107 do
 for j=minsafe.h,maxsafe.h do
  getc(i,j,i-1,i+1,j-1,j+1)
 end end
 yield()--calc cwy
 for i=108,116 do  
 for j=minsafe.h,maxsafe.h do
  getc(i,j,i-1,i+1,j-1,j+1)
 end end
 --yield()--calc cwy
 for i=117,126 do
 for j=minsafe.h,maxsafe.h do
  getc(i,j,i-1,i+1,j-1,j+1)
 end end
 yield()--calc cwy
 
 --left column 
 --i,j,⬅️,➡️,⬆️,⬇️
 i=0
 for j=minsafe.h,maxsafe.h do
  getc(i,j,size.w,i+1,j-1,j+1) 
 end
 
 --right column 
 --i,j,⬅️,➡️,⬆️,⬇️
 i=size.w
 for j=minsafe.h,maxsafe.h do
  getc(i,j,i-1,0,j-1,j+1) 
 end

 --top row 
 --i,j,⬅️,➡️,⬆️,⬇️
 j=cwy_o
 for i=minsafe.w,maxsafe.w do
  getc(i,j,i-1,i+1,size.h,1) 
 end 

 --top row 
 --i,j,⬅️,➡️,⬆️,⬇️
 j=size.h
 for i=minsafe.w,maxsafe.w do
  getc(i,j,i-1,i+1,j-1,0) 
 end 

 --top left
 --i,j,⬅️,➡️,⬆️,⬇️ 
  getc(0,cwy_o,size.w,1,size.h,1) 

 --top right 
 --i,j,⬅️,➡️,⬆️,⬇️ 
  getc(size.w,cwy_o,size.w-1,0,size.h,1) 
   
 --bottom left 
 --i,j,⬅️,➡️,⬆️,⬇️
  getc(0,size.h,size.w,1,size.h-1,0) 
  
 --bottom right
 --i,j,⬅️,➡️,⬆️,⬇️ 
  getc(size.w,size.h,size.w-1,0
 ,size.h-1,0)   
  
 
-------------------------------
-- apply simulation          --
-------------------------------
 last_i=-1
 cwy_stable:clr()
 
 for i=0,8 do 
 for j=cwy_o,size.h do
  local l1 = g[i][j]&1 
  g[i][j]=(g[i][j]&2)>>1
  l1=l1&(g[i][j]&1)
  if l1>0 then
   add(cwy_stable.vs,{i=i,j=j}) 
  end end end 
 yield()--apply cwy 
 for i=9,17 do 
 for j=cwy_o,size.h do
  local l1 = g[i][j]&1 
  g[i][j]=(g[i][j]&2)>>1
  l1=l1&(g[i][j]&1)
  if l1>0 then
   add(cwy_stable.vs,{i=i,j=j}) 
  end end end 
 yield()--apply cwy  
 for i=18,26 do 
 for j=cwy_o,size.h do
  local l1 = g[i][j]&1 
  g[i][j]=(g[i][j]&2)>>1
  l1=l1&(g[i][j]&1)
  if l1>0 then
   add(cwy_stable.vs,{i=i,j=j}) 
  end end end 
 yield()--apply cwy   
 for i=27,35 do 
 for j=cwy_o,size.h do
  local l1 = g[i][j]&1 
  g[i][j]=(g[i][j]&2)>>1
  l1=l1&(g[i][j]&1)
  if l1>0 then
   add(cwy_stable.vs,{i=i,j=j}) 
  end end end 
 yield()--apply cwy   
 for i=36,44 do 
 for j=cwy_o,size.h do
  local l1 = g[i][j]&1 
  g[i][j]=(g[i][j]&2)>>1
  l1=l1&(g[i][j]&1)
  if l1>0 then
   add(cwy_stable.vs,{i=i,j=j}) 
  end end end 
 yield()--apply cwy   
 for i=45,53 do 
 for j=cwy_o,size.h do
  local l1 = g[i][j]&1 
  g[i][j]=(g[i][j]&2)>>1
  l1=l1&(g[i][j]&1)
  if l1>0 then
   add(cwy_stable.vs,{i=i,j=j}) 
  end end end 
 yield()--apply cwy   
 for i=54,62 do 
 for j=cwy_o,size.h do
  local l1 = g[i][j]&1 
  g[i][j]=(g[i][j]&2)>>1
  l1=l1&(g[i][j]&1)
  if l1>0 then
   add(cwy_stable.vs,{i=i,j=j}) 
  end end end 
 yield()--apply cwy   
 for i=63,71 do 
 for j=cwy_o,size.h do
  local l1 = g[i][j]&1 
  g[i][j]=(g[i][j]&2)>>1
  l1=l1&(g[i][j]&1)
  if l1>0 then
   add(cwy_stable.vs,{i=i,j=j}) 
  end end end 
 yield()--apply cwy   
 for i=72,80 do 
 for j=cwy_o,size.h do
  local l1 = g[i][j]&1 
  g[i][j]=(g[i][j]&2)>>1
  l1=l1&(g[i][j]&1)
  if l1>0 then
   add(cwy_stable.vs,{i=i,j=j}) 
  end end end 
 yield()--apply cwy   
 for i=81,89 do 
 for j=cwy_o,size.h do
  local l1 = g[i][j]&1 
  g[i][j]=(g[i][j]&2)>>1
  l1=l1&(g[i][j]&1)
  if l1>0 then
   add(cwy_stable.vs,{i=i,j=j}) 
  end end end 
 yield()--apply cwy   
 for i=90,97 do 
 for j=cwy_o,size.h do
  local l1 = g[i][j]&1 
  g[i][j]=(g[i][j]&2)>>1
  l1=l1&(g[i][j]&1)
  if l1>0 then
   add(cwy_stable.vs,{i=i,j=j}) 
  end end end 
 yield()--apply cwy   
 for i=98,106 do 
 for j=cwy_o,size.h do
  local l1 = g[i][j]&1 
  g[i][j]=(g[i][j]&2)>>1
  l1=l1&(g[i][j]&1)
  if l1>0 then
   add(cwy_stable.vs,{i=i,j=j}) 
  end end end 
 yield()--apply cwy   
 for i=107,115 do 
 for j=cwy_o,size.h do
  local l1 = g[i][j]&1 
  g[i][j]=(g[i][j]&2)>>1
  l1=l1&(g[i][j]&1)
  if l1>0 then
   add(cwy_stable.vs,{i=i,j=j}) 
  end end end 
 yield()--apply cwy   
 for i=116,127 do 
 for j=cwy_o,size.h do
  local l1 = g[i][j]&1 
  g[i][j]=(g[i][j]&2)>>1
  l1=l1&(g[i][j]&1)
  if l1>0 then
   add(cwy_stable.vs,{i=i,j=j}) 
  end end end 
 yield()--apply cwy   

-------------------------------
-- glitch data               --
------------------------------- 
blkr={0,1}
for blk in all(gblk) do
  g[blk.i][blk.j]=0
  g[trw[blk.i+1]][blk.j]=0
  g[blk.i][trh[blk.j+1]]=0
  g[trw[blk.i+1]][trh[blk.j+1]]=0 
end



-------------------------------
-- create draw data          --
------------------------------- 
 local gm=24576+4*16*cwy_o
 lc=8
 dc=0
 
 local t={}
 t[0]={} t[0][0]=0x1000*dc
 t[0][1]=0x1000*lc
 
 t[1]={} t[1][0]=0x0100*dc
  t[1][1]=0x0100*lc
  
 t[2]={} t[2][0]=0x0010*dc
  t[2][1]=0x0010*lc
  
 t[3]={} t[3][0]=0x0001*dc
  t[3][1]=0x0001*lc
  
 t[4]={} t[4][0]=0x.1000*dc
  t[4][1]=0x.1000*lc
  
 t[5]={} t[5][0]=0x.0100*dc
  t[5][1]=0x.0100*lc
  
 t[6]={} t[6][0]=0x.0010*dc
  t[6][1]=0x.0010*lc
  
 t[7]={} t[7][0]=0x.0001*dc
  t[7][1]=0x.0001*lc

 j=cwy_o
 i=0
  
 while gm>0 do	  
	 gdd[gm] 
	 = t[0][g[i|7][j]]
	 | t[1][g[i|6][j]]
	 | t[2][g[i|5][j]]
	 | t[3][g[i|4][j]]
	 | t[4][g[i|3][j]]
	 | t[5][g[i|2][j]]
	 | t[6][g[i|1][j]]
	 | t[7][g[i][j]]	 
	  
  gm+=4 --1
		i=8
		
		gdd[gm] 
	  = t[0][g[i|7][j]]
	  | t[1][g[i|6][j]]
	  | t[2][g[i|5][j]]
	  | t[3][g[i|4][j]]
	  | t[4][g[i|3][j]]
	  | t[5][g[i|2][j]]
	  | t[6][g[i|1][j]]
	  | t[7][g[i][j]]
	 
	 gm+=4 --2
		i=16
		
		gdd[gm] 
	  = t[0][g[i|7][j]]
	  | t[1][g[i|6][j]]
	  | t[2][g[i|5][j]]
	  | t[3][g[i|4][j]]
	  | t[4][g[i|3][j]]
	  | t[5][g[i|2][j]]
	  | t[6][g[i|1][j]]
	  | t[7][g[i][j]]
	 
	 gm+=4 --3
		i=24		
		
		gdd[gm] 
	  = t[0][g[i|7][j]]
	  | t[1][g[i|6][j]]
	  | t[2][g[i|5][j]]
	  | t[3][g[i|4][j]]
	  | t[4][g[i|3][j]]
	  | t[5][g[i|2][j]]
	  | t[6][g[i|1][j]]
	  | t[7][g[i][j]]
	 
	 gm+=4 --4
		i=32
		
		gdd[gm] 
	  = t[0][g[i|7][j]]
	  | t[1][g[i|6][j]]
	  | t[2][g[i|5][j]]
	  | t[3][g[i|4][j]]
	  | t[4][g[i|3][j]]
	  | t[5][g[i|2][j]]
	  | t[6][g[i|1][j]]
	  | t[7][g[i][j]]
	 
	 gm+=4 --5
		i=40	
		
		gdd[gm] 
	  = t[0][g[i|7][j]]
	  | t[1][g[i|6][j]]
	  | t[2][g[i|5][j]]
	  | t[3][g[i|4][j]]
	  | t[4][g[i|3][j]]
	  | t[5][g[i|2][j]]
	  | t[6][g[i|1][j]]
	  | t[7][g[i][j]]
	 
	 gm+=4 --6
		i=48	
		
		gdd[gm] 
	  = t[0][g[i|7][j]]
	  | t[1][g[i|6][j]]
	  | t[2][g[i|5][j]]
	  | t[3][g[i|4][j]]
	  | t[4][g[i|3][j]]
	  | t[5][g[i|2][j]]
	  | t[6][g[i|1][j]]
	  | t[7][g[i][j]]
	 
	 gm+=4 --7
		i=56
		
		gdd[gm] 
	  = t[0][g[i|7][j]]
	  | t[1][g[i|6][j]]
	  | t[2][g[i|5][j]]
	  | t[3][g[i|4][j]]
	  | t[4][g[i|3][j]]
	  | t[5][g[i|2][j]]
	  | t[6][g[i|1][j]]
	  | t[7][g[i][j]]
	 
	 gm+=4 --18
		i=64
		
		gdd[gm] 
	  = t[0][g[i|7][j]]
	  | t[1][g[i|6][j]]
	  | t[2][g[i|5][j]]
	  | t[3][g[i|4][j]]
	  | t[4][g[i|3][j]]
	  | t[5][g[i|2][j]]
	  | t[6][g[i|1][j]]
	  | t[7][g[i][j]]
	 
	 gm+=4 --9
		i=72
							
		gdd[gm] 
	  = t[0][g[i|7][j]]
	  | t[1][g[i|6][j]]
	  | t[2][g[i|5][j]]
	  | t[3][g[i|4][j]]
	  | t[4][g[i|3][j]]
	  | t[5][g[i|2][j]]
	  | t[6][g[i|1][j]]
	  | t[7][g[i][j]]
	 
	 gm+=4 --10
		i=80
		
		gdd[gm] 
	  = t[0][g[i|7][j]]
	  | t[1][g[i|6][j]]
	  | t[2][g[i|5][j]]
	  | t[3][g[i|4][j]]
	  | t[4][g[i|3][j]]
	  | t[5][g[i|2][j]]
	  | t[6][g[i|1][j]]
	  | t[7][g[i][j]]
	 
	 gm+=4 --11
		i=88
		
		gdd[gm] 
	  = t[0][g[i|7][j]]
	  | t[1][g[i|6][j]]
	  | t[2][g[i|5][j]]
	  | t[3][g[i|4][j]]
	  | t[4][g[i|3][j]]
	  | t[5][g[i|2][j]]
	  | t[6][g[i|1][j]]
	  | t[7][g[i][j]]
	 
	 gm+=4 --12
		i=96
		
		gdd[gm] 
	  = t[0][g[i|7][j]]
	  | t[1][g[i|6][j]]
	  | t[2][g[i|5][j]]
	  | t[3][g[i|4][j]]
	  | t[4][g[i|3][j]]
	  | t[5][g[i|2][j]]
	  | t[6][g[i|1][j]]
	  | t[7][g[i][j]]
	 
	 gm+=4 --13
		i=104
		
		gdd[gm] 
	  = t[0][g[i|7][j]]
	  | t[1][g[i|6][j]]
	  | t[2][g[i|5][j]]
	  | t[3][g[i|4][j]]
	  | t[4][g[i|3][j]]
	  | t[5][g[i|2][j]]
	  | t[6][g[i|1][j]]
	  | t[7][g[i][j]]
	 
	 gm+=4 --14
		i=112
		
		gdd[gm] 
	  = t[0][g[i|7][j]]
	  | t[1][g[i|6][j]]
	  | t[2][g[i|5][j]]
	  | t[3][g[i|4][j]]
	  | t[4][g[i|3][j]]
	  | t[5][g[i|2][j]]
	  | t[6][g[i|1][j]]
	  | t[7][g[i][j]]
	 
	 gm+=4 --15
		i=120					
							
		gdd[gm] 
	  = t[0][g[i|7][j]]
	  | t[1][g[i|6][j]]
	  | t[2][g[i|5][j]]
	  | t[3][g[i|4][j]]
	  | t[4][g[i|3][j]]
	  | t[5][g[i|2][j]]
	  | t[6][g[i|1][j]]
	  | t[7][g[i][j]]
	 														 
  j+=1
  i=0
  gm+=4 --16
 end --while
 last_i=-1
-------------------------------
-- read simulation           --
-------------------------------
 yield()

 for c in all(hzl.vs) do
  if isvtl(c.i,c.j) then
   vtl:sadd(c.i,c.j,c)
  end
 end
 hzl:clr()

 local loop=0
 local hzlperf=cwy_perf
 local sblk=nil
 for c in all(cwy_stable.vs) do  
  ptrn=chkptrn(c.i,c.j)
  if ptrn==1 then
   hzl:sadd(c.i,c.j,c)
  elseif ptrn==2 then  
   if 
    tblk:sadd(c.i,c.j,c)>blkage
   then
    if sblk==nil then
     sblk=c
    elseif rnd(10)>5 then
     sblk=c
    end
   end    
  end  
    
  loop+=1 
  if loop>hzlperf then
   loop=0
   yield()
  end   
 end--loop on cwy_stable

 yield()
 
 for v in all(vtl.vs) do
  if v then
   addpoint(1,v.i,v.j)   
   add(focus,{i=v.i,j=v.j,l=0})
  end
  loop+=1
  if loop>cwy_perf then
  loop=0
  yield()
  end
 end
 vtl:clr()

 if sblk then
  tblk:clr()
  sblk.ok=true
  add(gblk,sblk)
  --no audio save token
  --radio:play(0,2)
  glitch2=8 
  blkage-=#gblk
		if #gblk>=2 then
		 for i=1,#gblk-1 do   
		  for j=0,25 do
		   t=j/25
		   ti = flr(gblk[i].i * (1-t) 
		   + gblk[i+1].i*t)
		   
		   tj=flr(gblk[i].j * (1-t) 
		   + gblk[i+1].j*t)
		   
		   for a=-3,3 do
		    for b=-3,3 do 
		     g[trw[ti+a]][trh[tj+b]]
		     =rnd(blkr)
		    end
		   end     
		  end
		 end
		end 
   
 end
------------------------------
-- restart simulation       --
------------------------------
 if #gblk < blklimit then
  sim_cwy=nil
  start_conway()
 else
  gridbreak=true
  glitch1=200
  console:clr()
  console:sadd(
   story_txt("grid break",3,"!") 
  )
  console:sadd(
   story_txt("memory corrupted",2,".") 
  )
  console:sadd(
   story_txt("[r] to reboot",2,".") 
  )
  console:sadd(
   story_txt("clr()",2," ",11) 
  )
  console:sadd(
   story_txt(
   "clr() failed with ✽",3,".") 
  )
  console:sadd(
   story_txt("clr(✽)",3,".",11) 
  )  
  console:sadd(
   story_txt("c✽r fa✽✽ err✽",3,"✽") 
  )  
  console:sadd(
   story_txt("r",3,".",11) 
  )  
  console:sadd(
   story_txt("wait",2,".") 
  )  
  console:sadd(
   story_h_bar(0,127,20)
  )
  console:sadd(
   story_h_bar(127,0,-20)
  )
  console:sadd(
   story_h_bar(0,127,20)
  )
  console:sadd(
   story_h_bar(127,0,-20)
  )
  --no audio save token
  --music(-1, 300)  
 end
end--simulation

--count living neighbours
function getc(i,j,⬅️,➡️,⬆️,⬇️)
 local c = 0+
 (g[⬅️][j]&1)+ 
 (g[⬅️][⬆️]&1)+
 (g[⬅️][⬇️]&1)+
 (g[i][⬆️]&1)+
 (g[i][⬇️]&1)+
 (g[➡️][j]&1)+
 (g[➡️][⬆️]&1)+
 (g[➡️][⬇️]&1)
 
 if c == 3 then
  g[i][j]=(g[i][j]&1)|2
 elseif c<2 or c>3 then
  g[i][j]=(g[i][j]&1)|0
 else
  g[i][j]=(g[i][j]<<1)|g[i][j]
 end
 
 return c 
end

--convert getc to next c
--conway rules
--[[
function setc(i,j,c) 
 if c == 3 then
  g[i][j]=(g[i][j]&1)|2
 elseif c<2 or c>3 then
  g[i][j]=(g[i][j]&1)|0
 else
  g[i][j]=(g[i][j]<<1)|g[i][j]
 end
end
--]]

function isvtl(i,j)
 --⬆️ vtl chk
 if not (g[i][trh[j-1]]&1)==1
 then return false end
 --⬇️ vtl chk
 if not (g[i][trh[j+1]]&1)==1
 then return false end 
 --⬅️ vtl chk
 if (g[trw[i-1]][j]&1)==1
 then return false end 
 --➡️ vtl chk
 if (g[trw[i+1]][j]&1)==1
 then return false end
 --⬆️⬆️
 if (g[i][trh[j-2]]&1)==1
 then return false end
 --⬇️⬇️
 if (g[i][trh[j+2]]&1)==1
 then return false end 
 --⬆️⬅️
 if (g[trw[i-1]][trh[j-1]]&1)==1
 then return false end 
 --⬆️➡️
 if (g[trw[i+1]][trh[j-1]]&1)==1
 then return false end
 --⬇️⬅️
 if (g[trw[i-1]][trh[j+1]]&1)==1
 then return false end
 --⬇️➡️
 if (g[trw[i+1]][trh[j+1]]&1)==1 
 then return false end
 --⬆️⬆️➡️
 if (g[trw[i+1]][trh[j-2]]&1)==1
 then return false end
 --⬆️⬆️⬅️
 if (g[trw[i-1]][trh[j-2]]&1)==1
 then return false end
 --⬇️⬇️➡️
 if (g[trw[i+1]][trh[j+2]]&1)==1
 then return false end
 --⬇️⬇️⬅️
 if (g[trw[i-1]][trh[j+2]]&1)==1 
 then return false end
 
 return true
end

--check pattern
function chkptrn(i,j)
 --⬅️ chk hzl 
 if (g[trw[i-1]][j]&1)==1
  --maybe hzl  
 then 
 --➡️ chk hzl
 if not (g[trw[i+1]][j]&1==1)
 then return 0 end
 --⬆️ chk hzl
 if (g[i][trh[j-1]]&1)==1 
 then return 0 end
 --⬇️ chk hzl
 if (g[i][trh[j+1]]&1)==1 
 then return 0 end
 --➡️➡️ chk hzl
 if (g[trw[i+2]][j]&1)==1
 then return 0 end 
 --⬅️⬅️ chk hzl
 if (g[trw[i-2]][j]&1)==1
 then return 0 end 
 --⬆️➡️ chk hzl
 if (g[trw[i+1]][trh[j-1]]&1)==1 
 then return 0 end
 --⬇️➡️ chk hzl
 if (g[trw[i+1]][trh[j+1]]&1)==1 
 then return 0 end 
 --⬇️⬅️ chk hzl
 if (g[trw[i-1]][trh[j+1]]&1)==1 
 then return 0 end 
 --⬆️⬅️ chk hzl
 if (g[trw[i-1]][trh[j-1]]&1)==1 
 then return 0 end
 --⬆️➡️➡️ chk hzl
 if (g[trw[i+2]][trh[j-1]]&1)==1 
 then return 0 end 
 --⬇️➡️➡️ chk hzl
 if (g[trw[i+2]][trh[j+1]]&1)==1 
 then return 0 end 
 --⬆️⬅️⬅️ chk hzl
 if (g[trw[i-2]][trh[j-1]]&1)==1 
 then return 0 end 
 --⬇️➡️➡️ chk hzl
 if (g[trw[i-2]][trh[j+1]]&1)==1 
 then return 0 end
    
 return 1
 --end maybe hzl 
 --⬇️
 elseif (g[i][trh[j+1]])&1==1
 then
 --maybe blk
 --➡️ chk blk
 if not (g[trw[i+1]][j]&1==1)
 then return 0 end

 --⬅️ chk blk
 --if (g[trw[i-1]][j]&1)==1
 --then return 0 end
 --already check for hzl
 
 --⬆️ chk blk
 if (g[trw[i]][j-1]&1)==1
 then return 0 end

 --➡️➡️ chk blk
 if (g[trw[i+2]][j]&1)==1
 then return 0 end

 --⬆️➡️ chk blk
 if (g[trw[i+1]][trh[j-1]]&1)==1
 then return 0 end

 --⬇️➡️ chk blk
 if not (g[trw[i+1]][trh[j+1]]&1==1)
 then return 0 end 

 --⬆️⬅️ chk blk
 if (g[trw[i-1]][trh[j-1]]&1)==1
 then return 0 end

 --⬇️⬅️ chk blk
 if (g[trw[i-1]][trh[j+1]]&1)==1
 then return 0 end

 --➡️➡️⬆️ chk blk
 if (g[trw[i+2]][trh[j-1]]&1)==1
 then return 0 end 

 --➡️➡️⬇️ chk blk
 if (g[trw[i+2]][trh[j+1]]&1)==1
 then return 0 end 

 --➡️➡️⬇️⬇️ chk blk
 if (g[trw[i+2]][trh[j+2]]&1)==1
 then return 0 end

 --➡️⬇️⬇️ chk blk
 if (g[trw[i+1]][trh[j+2]]&1)==1
 then return 0 end
 
 --⬇️⬇️ chk blk
 if (g[i][trh[j+2]]&1)==1
 then return 0 end 

 --⬅️⬇️⬇️ chk blk
 if (g[trw[i-1]][trh[j+2]]&1)==1
 then return 0 end

 return 2
 --end maybe blk
 end

 return 0 
 --end chk ptrn  
end

function tore_h(x)
 if x<0 then x=size.h+x+1 end
 if x>size.h then x=x-size.h-1 end
 return x
end

function tore_w(x)
 if x<0 then x=size.w+x+1 end
 if x>size.w then x=x-size.w-1 end
 return x
end
-->8
--points & effects
pts={}
focus={}

function addpoint(p,i,j) 
 pt={}
 pt.x=i
 pt.y=j
 pt.spd=0.6
 pt.life=30
 pt.v=p
 pt.ptsp=rnd(ptsplib)
 add(pts,pt)
end

rndmove={1,1,1,1,1,1,-1,0,1,1}

ptsplib={
 {s=50,z=1},
 {s=23,z=1},
 {s=24,z=1},
 {s=39,z=1},
 {s=40,z=1},
 {s=51,z=2}
}

fkpoint={"♥","✽","♪","◆"}

function getfkpoint(p)
 local fk=""
 for i=0,1 do
  fk=fk..rnd(fkpoint)
 end
 return fk
end

function drawpoints() 
 for pt in all(pts) do
  
  spr(pt.ptsp.s,
  pt.x-1,pt.y-2,
  pt.ptsp.z,pt.ptsp.z)
  
  local spd = pt.spd+pt.life/30
  pt.y-=spd
  --pt.life+=1
  --if pt.life <= 0 then
  if pt.y <= 10 then
  del(pts,pt)
  ck+=pt.v
  rando:move(rnd(rndmove))
  end
 end
 
 for hh in all(hzl.vs) do
  pset(hh.i,hh.j,12)  
 end
 
 ---[[
 for blk in all(gblk) do
  if blk.ok then
    rect(
     blk.i-1,blk.j-1,
     blk.i+1,blk.j+1,
     12)
  end
 end
 
 if #gblk>=2 then
  for i=1,#gblk-1 do
   if gblk[i].ok then
    line(gblk[i].i,gblk[i].j,
    gblk[i+1].i, gblk[i+1].j,
    12)
   end
  end
 end
 --]]
 
 for f in all(focus) do
  if f.l<3 then
   pset(f.i,f.j-1,12)
   pset(f.i,f.j+1,12)  
  elseif f.l<6 then
   pset(f.i,f.j-2,12)
   pset(f.i,f.j+2,12) 
  end
  
  f.l+=1
  
  if f.l>=6 then--todo pool 
   del(focus,f)
  end
 end
end
-->8
--snake
snake={
 i=10,
 j=10,
 s=1,--size
 dx=-1,
 dy=0,
 dir=➡️,
 pos={{i=10,j=10},{i=9,j=10},
 {i=8,j=10}},
 col={14,14},
 gw=false,
 speed=1
}

function drawsnake() 
	for i=1,#snake.pos do
	 local body = snake.pos[i]
	 pcol=snake.col[1]
	 if i%2==0 then
	  pcol=snake.col[2]
	 end
	 pset(body.i,body.j,pcol) 
	end
end

function movesnake() 
 local p = snake.pos[1]
 local lx=p.i
 local ly=p.j
 
 --choose movr toward dx/y
 if p.i==snake.dx and
  p.j==snake.dy then
  return true
 end
 
 if snake.dir == ➡️ 
 then
  if p.i<snake.dx then
   p.i+=1--continue ➡️
  elseif p.j<snake.dy then
   p.j+=1
   snake.dir=⬇️
  elseif p.j>snake.dy then
   p.j-=1
   snake.dir=⬆️
  elseif p.j<63 then
   p.j+=1
   snake.dir=⬇️  
  else
   p.j-=1
   snake.dir=⬆️  
  end
 elseif snake.dir == ⬅️
 then
  if p.i > snake.dx then
   p.i-=1--continue ⬅️
  elseif p.j<snake.dy then
   p.j+=1
   snake.dir=⬇️
  elseif p.j>snake.dy then
   p.j-=1
   snake.dir=⬆️
  elseif p.j<63 then
   p.j+=1
   snake.dir=⬇️  
  else
   p.j-=1
   snake.dir=⬆️
  end  
 elseif snake.dir == ⬆️
 then
  if p.j > snake.dy then
   p.j-=1
  elseif p.i<snake.dx then
   p.i+=1
   snake.dir=➡️
  elseif p.i>snake.dx then
   p.i-=1
   snake.dir=⬅️
  elseif p.i<63 then
   p.i+=1
   snake.dir=➡️  
  else
   p.i-=1
   snake.dir=⬅️  
  end--end dir was ⬆️ 
 else--⬇️ 
  if p.j < snake.dy then
   p.j+=1--continue ⬇️
  elseif p.i<snake.dx then
   p.i+=1
   snake.dir=➡️
  elseif p.i>snake.dx then
   p.i-=1
   snake.dir=⬅️
  elseif p.i<63 then
   p.i+=1
   snake.dir=➡️  
  else
   p.i-=1
   snake.dir=⬅️ 
  end
 end
 
 local tx=0
 local ty=0
  
 for i=2,#snake.pos do
  p= snake.pos[i] 
  tx=p.i
  ty=p.j
  p.i=lx
  p.j=ly
  lx=tx
  ly=ty
 end
 if snake.gw then
  snake.gw=false
  snake.s=snake.s+1
  np={i=tx,j=ty}
  add(snake.pos,np)
  snake.speed+=rnd({0,1})
 end
 return false
end

-->8
--astar
--[[
pathx1=0
pathx2=0
pathy1=0
pathy2=0
astar=nil
astarperf=200

function node(_i,_j)
 n={
	 i=_i,
	 j=_j,
	 --parent node
	 p=nil,
	 --gcost to move next cell
	 g = 0,
	 --hcost to moe to the goal
	 h = 0,
	 
	 f=function(self)
	  return self.g+self.h
	 end
 } 
 return n
end

function ax() 
 
 astar=nil
 
 local si = pathx1
 local ti = pathx2
 local sj = pathy1
 local tj = pathy2
 
 local s = node(si,sj)
 local t= node(ti,tj)
 local opn=list2d(size)
 local cld=list2d(size)
 
 opn:sadd(s.i,s.j,s)
 
 local b=0
 while #opn.vs>0 do
  local c=opn.vs[1]
  for i=2,#opn.vs do
   if opn.vs[i]:f() < c:f() or
    opn.vs[i]:f() == c:f() and
    opn.vs[i].h<c.h then
    c=opn.vs[i]
   end--if cost 
  end--for opn
  
  opn:sdel(c.i,c.j,c)
  cld:sadd(c.i,c.j,c)
  
  if c.i==t.i and c.j==t.j then
   return getfinalpath(s,c)
  end
  
  --todo tore it
  ngh={}
  if c.i>0 then
   add(ngh,node(c.i-1,c.j))
  end
  if c.i<size-1 then
   add(ngh,node(c.i+1,c.j))
  end 
  if c.j>0 then
   add(ngh,node(c.i,c.j-1))
  end
  if c.j<size-1 then
   add(ngh,node(c.i,c.j+1))
  end  

  for n in all(ngh) do
   if iswalk(n,cld) then	
	  
	  --g is gcost
   mcost= c.g + manhat(c,n)
   
   if mcost < n.g 
   or not opn:has(n.i,n.j)
   then
    n.gcost=mcost
    --t is target
    n.hcost=manhat(n,t)
    n.p=c
    
    opn:sadd(n.i,n.j,n)
   end--if cost check	    
   end--end node valid to moveon
  end--end for neighbours
  b=b+1
  if b>=astarperf then
   b=0
   yield()
  end
 end-- while opn
end

--todo improve by tore
function manhat(n1,n2)
 local ix = abs(n1.i-n2.i)
 local iy = abs(n2.j-n2.j)
 return ix+iy
end

function getfinalpath(sn,en)
 path = {}
 local n = en
 local b1=0
 while n and n != sn do
  add(path,n)
  n=n.p
  b1+=1
 end
 --return a stack
 astar=path
end

--can walk on it
function iswalk(n,l)
 if is♥(n.i,n.j) or
    l:has(n.i,n.j)
 then
  return false
 end
 
 return true
end
--]]
-->8
function list2d(w)
 l={
  vs={},--values
  ks={},--keys
  w=w,--size
  
  --safe add an obj
  sadd=function(self,i,j,v)
   local k = i*self.w+j
   if self.ks[k] == nil then
    add(self.vs,v)
    self.ks[k]=1
    return 1
   else
    self.ks[k]+=1
    return self.ks[k]
   end
  end,
  
  geta=function(self,v)
   local k = v.i*self.w+v.j
   return self.ks[k]
  end,
  --safe del an obj
  sdel=function(self,i,j,v)
   local k = i*self.w+j
   if self.ks[k] then
    del(self.vs,v)
    self.ks[k]=nil
   end  
  end,
  
  --is the value exist
  has=function(self,i,j)
   local k = i*self.w+j
   if self.ks[k] then
    return true
   end
   return false
  end,
  
  clr=function(self)
   self.vs={}
   self.ks={}   
  end,
 }
 return l
end
-->8
--panel
txtlib= {
 "cookie collective",
 "cookie collective",
 "cookie anaglyphe",
 "cookie collective",
 "cookie crash party",
 "cookie collective",
 "cookie glitch",
 "cookie collective",
 "cookie divagation",
 "cookie collective",
 "cookie live coding",
 "cookie collective"}

function initpannel()

 rando = {}
 i=0
 rando.path={}
 while i < 30 do
  add(rando.path,".")
  i+=1
 end
 rando.path[3]="웃"
 rando.path[#rando.path]="⌂"
 rando.pos=3
 printh("init pannel "..#rando.path, "log.txt")
 
 rando.move=function(self,d)
  printh(cwy_f.." move "..d, "log.txt")
  local npos = self.pos+d
  if npos>#rando.path then
   npos=1
  elseif npos<1 then
   npos=#rando.path
  end
  i=0
  while i < 30 do
   rando.path[i]="."
   i+=1
  end
  rando.path[npos]="웃"
  self.pos=npos
  if npos==#rando.path then
   rando.path[#rando.path-1]="♪"
  end
  rando.path[#rando.path]="⌂"
 end
 
	txt={}
	pnlx=0
	for i=1,#txtlib do
	 local lbl={t=txtlib[i], x=pnlx}
	 add(txt,lbl)
	 pnlx+= #lbl.t*4+4
	end
	
	pnls=1

end

function drawpannel()
 --banner info
 rectfill(0,0,127,6,12)
 for lbl in all(txt) do
  print(lbl.t,lbl.x,1,8)
  lbl.x-=pnls
  
  if lbl.x<-(#lbl.t*4+4) then
  lbl.x=pnlx-(#lbl.t*4+4)
  end
 end

 --score info 
 rectfill(0,7,127,14,8)
 --[[
 --revision 2024 demo
 stext = "COOKIES :"..ck
 if #gblk>0 then
  stext=
  stext.." GLITCH :"..#gblk
 end
 --]]
 stext=""
 for rp in all(rando.path) do
  stext=stext..rp
 end
	print(stext,0,8,12)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000cc8000000c800000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000c800c8000000c8000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ccc80c800c800c8000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000c80cc80ccc80c8000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000cc800c80cc8000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000cc8000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000008cc000008c0000000000000000000000000000000000000000000000000000000000
00000000000000000c80c8000c80c80cc80cc80000000000000000000c8008c0000008c000000000000000000000000000000000000000000000000000000000
0000000000000000ccc8c800ccc8c80cc80cc8000000000000000000ccc808c00c8008c000000000000000000000000000000000000000000000000000000000
00000000000000000c80c8000c80c80cc80cc80000000000000000000c8008ccccc808c000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000008cc0c8008cc00000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000008cc00000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000cc800000cccc80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000c800c800c800c80c80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000ccc80c80ccc80c80c80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000c80cc800c80cc8cc80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000cc800000cc8cc80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
8c8c8c888c888cccccc88cc88c8ccc8ccc888cc88c888c888c8c8c888cccccc88cc88cc88c8c8c888c888cccccc88c888c888cc88c8c8ccccc888c888c888c88
8c8c8cc8cc8ccccccc8ccc8c8c8ccc8ccc8ccc8cccc8ccc8cc8c8c8ccccccc8ccc8c8c8c8c8c8cc8cc8ccccccc8ccc8c8c8c8c8ccc8c8ccccc8c8c8c8c8c8cc8
8c88ccc8cc88cccccc8ccc8c8c8ccc8ccc88cc8cccc8ccc8cc8c8c88cccccc8ccc8c8c8c8c88ccc8cc88cccccc8ccc88cc888c888c888ccccc888c888c88ccc8
8c8c8cc8cc8ccccccc8ccc8c8c8ccc8ccc8ccc8cccc8ccc8cc888c8ccccccc8ccc8c8c8c8c8c8cc8cc8ccccccc8ccc8c8c8c8ccc8c8c8ccccc8ccc8c8c8c8cc8
cc8c8c888c888cccccc88c88cc888c888c888cc88cc8cc888cc8cc888cccccc88c88cc88cc8c8c888c888cccccc88c8c8c8c8c88cc8c8ccccc8ccc8c8c8c8cc8
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
888888888888888888888888888888888888ccc8888888888888888888888888888888888888ccc8888888888888888888888888888888888888888888888888
8cc88cc88cc8c8c8ccc8ccc88cc888888c88c8c888888cc8c888ccc8ccc88cc8c8c888888c88c8c8888888888888888888888888888888888888888888888888
c888c8c8c8c8cc888c88cc88c88888888888ccc88888c888c8888c888c88c888c8c888888888c8c8888888888888888888888888888888888888888888888888
c888c8c8c8c8c8c88c88c88888c888888c88c8c88888c8c8c8888c888c88c888ccc888888c88c8c8888888888888888888888888888888888888888888888888
8cc8cc88cc88c8c8ccc88cc8cc8888888888ccc88888ccc88cc8ccc88c888cc8c8c888888888ccc8888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
00000000000000000000008800000000000000000000000888888800000000000000000000000080000000000000000000008000000000000000000000000000
88008880000000000000080000000000000000008080008000000088000000000080880800008888088800000000000000000008800000000000000000800000
08008008000000000000008000000000000000000000000000880888000880008000800800008800880088000000000000880080080000000000000000880000
00008800800000000000000000000000000000000800000080008800008808808888088800000000008000880000000000880000000000000000000000088800
00000088000000000000000000000008000000008880000088000808800008088800088800008800880800880000000000000000000000000000000000088800
80000000000000000008000000000080800008080800000000000800080088800000080000000000088800808000000000000000000000000000008880008800
80800000000000000080800000000080800000888000800000008808080008800000008800000000000888888000000800000888000000000000000000008000
88800000000000000800000000000008000000080000880000008800000000000000008000000000800088008000000800000880808808880000000000888000
00000000000000000800008800000000000808000008008800000800080000008800008800000000800808880000000800008808000000888800000000888000
00000000000008880000008008080000000808000000008008000080080000000800000000000000800000000000000000808000888000008000000000808000
00000808800008080008880808080000008800000000080880800008000000080880000000008000080880000000000000800000880800008000000000880880
00000888888000000808808000000000088000000000000808000000000000008088800000080000000800008000000000008000080800880000880000008000
00088800000000000000000000880000808800000000000880808000000000008000800000000800008000008800000000088000008000000008808000000000
00000000000000000000008088008000000000000000000888008800880000000888800000000000088800000000000000080000000000000000008800000000
00080800000000000000000080008000000000000000000008000880880000000000000000888000088008808800000000000000000000000000000800000000
08008000000000000000000000000000000000000000000000880880800000000000000888000000000000088800000000000000000000000000080800000080
08000000000008800000000880000000000080000888008880088000800000000000000000000000000800000000000000000000000000000000080800000000
08800000000008800000000000008800000008000888000080000800080000000000000008000000000088000800080088000000000000000000080880000800
88800000000000000000000000008880000080000888000008880000000000000000000888000000000000000000088888000000000000000000080080000880
08800000000080000008000000000000800000080008800080000800000000000000000000000000000000088000000088000008888800000000080080000000
00000000008080000888800000000000800000888000880808008000000000000000000000000000000000000000000000000080088880000000008800000000
00000000088000008880800000000000080000888800080800800800000000000000000000000000000000000008080000000088880800000000000000000000
00000088080000088000000000000080880000000000008880800800000000000000000000000000000000000008880000000080088088800000000000000000
00000800088088080800000000000008880000800000000000888000000000000000000888000000000000000000008000000008008808880000080000000000
00000880008888808800000000000000000000888800000000880000000000000000000088080000000000000080080000000008008808088000008800000000
00008088880800808800000000000000000000888800000000000000000000000000000008880000000000000080008000000000888000000888088800000000
00008800088000008080800000088880000000000800000000000000000000000000000000800000000000000000088000000000000000080088880800000000
00000000800800000800008808880080000000000000000000000000000000000000000000000000000000000080880000000000000000000808808000000000
00000000008880000080000080000008000000000000000000000000000000000000000000000880000880000080800008880000080000000000008000000000
00808800008880000000080888800008000088000000000000000000000008800080000000000088008080000000000888888000080000000000000000000008
80008800000000000000008000000008800800000000008888808000000080088888000000000080000000000000000888008800080000000000000000000008
80000880000000000888000000000880800000000000880800000000000880080000800000000880800800000000000800008880000000000000000000000000
88088000000000000088000000000008880800080008000000000880000880888800880000000088000088000000000080808800000000000000000888000000
88080080000000000800000000000000888800808080800000008000800880000800080800000000000088800000000080008000000000000000008000000000
08008000000000000000000000000008008000800800088000080080000080000008000800000000800088880000000008880000000000000000008000808888
00088000000000000000000000000080000800880000000000000080080000000008880000800088000000008800000000000000000000000000088080088080
00080000000000000000000000008080880080000000000800080000008000000000088000800000000000080000000000000000000000080000080080008000
000000000000008c8000000000008880000008880000000800000008880000000000000808088888000000000000000000000000000000808000880080000880
88880000000000000080000000000000008008000008000008000000880000008880000008080000080000000000000000000000000000808008800088000088
00000000000008000080000000000008008008088880000088000000000000088088000080008888008000000000000000000000008000080008880000000000
00000000000080000000000000008880080008008808000000000000000000080000008088800088808000000000000000008800080800000000000000000000
00000000000008800800000000080008800008808000000000000000000000880080000000888000008000800000088000000800080080000000000000000000
00000000000880088000000000800888008000000008000000000000000000008880000000000000000000088000080808800000080000000800008800000000
00000000000888800080000008000800008088000008000000888888800080808000000000000000000080800000008808000800000000000800008888808000
00088000000080000000000000888880880000008800000008088800000000000000000000000888000888000000000000808800000800000000000880000000
00000000000080080000000000088880080880008800000000000008000000000008000008800888800888000000000888008800800800000000000800000000
08800800000080000000880000000880888880800000000000000000800000000088800008000808808008000000000888080008808000888088080080088000
08000800000000000800888800000880000080088000000000000088008000000008800008000000888888000000000088800808008800888800008008800000
08008000008800088800080880880880000008008000000000000000088000000080000008008008800080000000000080008008008000800800000800000000
00880000880080000000008080880800000000000000000000000800080000000880008800080000008080000000000080000000008000880000000800000000
00000000088080000000000000080080000000000000000080000088800000000080888888800080008088000000000008080000000000880808008800000000
00000080800888000000000000080080000000000000000088800000000000000088080888000000000088000000000000800000800800008880000000000080
00000008800088000000000000080000000000000000000008000000000000000000080800000000000800800000000000000000000000000080000000080080
00000000800080000000000000000000000000000000000000000000000000000000800880000080000800000000008000088800008080000808000000080080
00000800000080000000000000000000000000000000080008000000000000000000000088000000000088000000080800088088000800000808000000808000
00000800080008000000000000080080008800000008888808000888000880000000088000080000800888000000088800880008000000000080088800880000
00000000000008800000000880000880800000808880000080000088000008000000000888008000080888000000088800000080000000000000080800000000
00008800080880800000000880000808000000088000800000000000000888000000000088008000000000000000088800000000000000000000888880000000
00008800008880000000000000000000000000088800000800000000000880000000000000000000000000000000088800000880000000000008800888000000
00000008080080000000000000000000000000000000000000000000000088000000000000000000000000000000888000000888000000000008080888000000
00000008008000000000000000008800008000000080000000800000000080000000000000000000000000000088080800000880000000000080800080880000
00000008000008880000008000000080000800808080000000800000000088000000000000000000000000000008008080000008000000000880808008080800
00800088088008800000008000880000000000808000008800080000000008080000000808000000000000000808800088800008800000000880080880880080
88800008080088000000000000008880000000080008000800880080000008880000008808880000000000000800000000800080000800000888000088880888
08800000880880000000000000080800000000000000808000808088800000880088088800800000000000000800080000800800000800000880000080000800
80000800008800000808000008000088000000000000000000088080800880880800088880800000000000000000008080800080800800008000000008088000
00008000008000088888000080880888088808800000000000008008880880000800000088000000000000000000808088000080000000008008000888888000
00008008000000888008000880800088800000880888000000000008088800000880000000000888000000000888800008088000000000008808808880008088
00808000088000880000000880008808808000000888000000800088080000000800008000008000800000008800088000800880000000008808800800000800
08000880008880000000000800000808808088888080000008008880800000000080008000000800000000000000800088088800008800000888000080000000
00808800000000000000000880088000800088008880000088888888800000000088000000000000080000000008000880088800000008800080000008800000
00800000088880000000080088880000000000008800000000000008080000000000080000000000000000000008088000000000880000000000000000808000
00088800000000000000800800000080008000000000000000000088008000000008008000000800800000008008800000000000800000000000000000808000
00088800000000000000080800000888800000000000088880880880080000000080008800000088000000008080000000000008808000080000000000000800
00000000000000088800000000008088000000000000880008080880000000000080008800000000000000000008000000800000800000008000000088008000
00000000000008000080000008808000000000000000008000888000000000000008800800000000000000088080000000888880888800008000000800800000
88800000000880800008000088888080000008000000000000800000000000000000000000880088000000088000000000888800880000080000000000000000
80088000000000800000000080080000000080800008800008000000000000000000000000880880880000880008880000000888000000000000080000000000
88000800000000008000800000000000000008000008800000000000000000000000000000000880880088800008880000000000000000000008080000000000
00880080000000000800800000000000000008880000080000000000000000000000000000000880080000800888800000000000000080808888080800080000
00000080000000000088800000080000000008000800008800000000000000880880000000000008000000000800000000000000000000000008000880880000
00008008000000000000000000888000000808000000000000000000008088880808000000000000000088800000000000000000000808080008000080000000
00000088080000080000000000808000008008880880000000000000000000000808800000000000000008800000000000008000000880800800008800800000
00000008080008008000000000000088088080008000000000000000080008088080000000000000008000000000880000000800000000008800080888000000
00000000800000008000000000000800800080000080008800000000080000088888000000000000088880000000000888888800000008000000088080000000
00000000000000008000000000000800000000000088880800000000000800000800000000000000800008000080000888800000000088000000800000000000
00000000000000000000008800888000000800888880000800000000008808800000000000000008800008000008000008088800000888080000000000000000
00000000000088080000008080888088008008008000800000000000000000000000000000000000800000008808088880000088800088808000000000000000
00000000880000000000000080880088800008080000000000000000000008800000000000000800000080000080000080000008080008888000000000000000
00000000888000000000000880080000000000800000000000000000088000000000000080008080000800008000000000000000008000808800000000000000
00000000008000000000080008800000008800000000008000000000080000000000008808000000000000080080000000000000008000000808000008800008
08088080000000000000080008000880008800000008088000000000800080800000000008000000000000008080000000000080000800000808000080000880
80008800000000808888808800008088000000000080000000000000088000800000080000000000000000000800000000000888800800000000000008800008
08888000000008880808080000080080000000000800008000000000000088800000880880000000000000000000000000000000888000000000000000000000
00008000000080080888808000880880008888008808808800000000000000000000800000000000800000000000000000000000000000000000000000800000
88888800000008800080808008000880088008008800008800000000000000000008808800000008800880000000000000000000000000080000000888800008
00880800000008888880000088800880000088000888880000000000000000000000800800000000000000000000000000000000000000808000008800000000
00008880000000880008000088880880008088000088800000000000000008808800080800000000000000000000088000000000000000800800008808000000
08888800000000000080000080008080008000000000000000000080000000008000088000000000000000000000888000000000000000088000008888800800
88880000000000000800000880008008008808000000000000000008000000000080880800000000000000000000888000000000000000000000000888808000
00000000000880000000080008000808080808000000000000000008800000008000800000000800000088000088000008000000000000000000080000808888
00000000000008000000008000800088088000000000008880000000000000008000000000008880000080800088000008000000000000000000880008080000
00000000000000000000080000800008080088000000008880000000000088880088800000000008808888000008800008000000088008800000000080000000
08000000000000000880008800000888000008000000000008800000800000808800008080000808000888880000008000000000088000000000000088800080
08000800000008800880000000080888000000000000000088800008880000008000008880880008000088008000008800000000888008800000000088800000
08000088800008800000000080800080000000000080800000000080880000000080000008800080008000000000000880800000000000000000080080008000
00000088088000000000000008000000000000000808080800800880000000000080008000008000080000000000000088800000008888000000008880080000
80000000088000000000080000000080000000000888000008000088000000008080008008088800000000000808800008888000088080000000000000008880
88000000088000000000808000000008000000000000800000000000000000000000000888000000000088088000880000008000088000000000000000000800
80008000000000000008000000000880000000000800080800000000000000000000000008000000000000000000880000800000800088000000000000000008
00000000000000000000800800000800000000000800000000000000000880000000000000000000000088000000000000880880088088000000000000000000
00000000000000000000088800000000000000000800000000000000000000000000000000000000000000000000000000880880088800000000000000000000

__sfx__
360100003f47337473304730b47300403214000140012400214000140011400114731147312473014001240002403004031540312403004033f47337473304730b47308403074030040300403114731147312473
010200002b0702b0002b0000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000002350073500b35010350163501d350263502d35002350073500b35010350163501d350263502d35002350073500b35010350163501d350263502d35028350283500b35010350163501d350263502d350
010800001115011150111500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3710000000003000030e57300003000030e5730c503000030e573285030c5030e573000030c5030e57300003000030e5730e503000030e57300003000030e5730e5030c5030e5730c5730e5030e5730c5730c573
491000001a3551a355003051a3551c355003051a3551a355003051a3551c3551a3551c3550030518355003051a3551a355003051a3551c355003051a3551a355003051a3551c3551a3551c355003051835500000
0010000003450064500745008450094500b4500d4500f450104501345016450174501a4501b4501d4501f4502045021450234502445026450284502a4502c45030450334503645038450394503b4503c4503d450
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 05424344
00 05424344
02 05444344
00 00424344
00 00424344
03 04054344
00 05044344

