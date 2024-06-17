local deck = {}
local players = {}
local poolCards = {}
local detWinner = {}

function deck.makeDeck()
  local shapes = { "Hearts", "Diamonds", "Clubs", "Spades" }
  local numbers = { "2", "3", "4", "5", "6", "7", "8", "9", "Jack", "Queen", "King", "Ace" }
  for a, number in ipairs(numbers) do
    for b, shape in ipairs(shapes) do
      table.insert(deck, { number, shape })
    end
  end
end

function deck.pickRandomCard()
  local randomCard = math.random(1, #deck)
  local card = deck[randomCard]
  table.remove(deck, randomCard)
  return card
end

function getCardValue(card)
  local value = card
  if value == "Jack" then
    return 11
  elseif value == "Queen" then
    return 12
  elseif value == "King" then
    return 13
  elseif value == "Ace" then
    return 14
  else
    return tonumber(value)
  end
end

function getSuitValue(suit)
  local value = suit
  if value == "Hearts" then
    return 1
  elseif value == "Diamonds" then
    return 2
  elseif value == "Clubs" then
    return 3
  elseif value == "Spades" then
    return 4
  end
end

function isRoyalFlush(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2)
  local values = { getCardValue(fcard1), getCardValue(scard1), getCardValue(tcard1), getCardValue(foucard1), getCardValue(
    fifcard1) }
  local suits = { getSuitValue(fcard2), getSuitValue(scard2), getSuitValue(tcard2), getSuitValue(foucard2), getSuitValue(
    fifcard2) }
  local reqValues = { 10, 11, 12, 13, 14 }
  table.sort(values)
  for a = 1, 5 do
    if values[a] ~= reqValues[a] then
      return false
    end
  end
  for i = 2, #suits do
    if suits[i] ~= suits[1] then
      return false
    end
  end
  return true
end

function isStraightFlush(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2)
  local values = { getCardValue(fcard1), getCardValue(scard1), getCardValue(tcard1), getCardValue(foucard1), getCardValue(
    fifcard1) }
  local suits = { getSuitValue(fcard2), getSuitValue(scard2), getSuitValue(tcard2), getSuitValue(foucard2), getSuitValue(
    fifcard2) }
  table.sort(values)
  for i = 2, 5 do
    if values[i] ~= values[i - 1] + 1 then
      return false
    end
  end
  for i = 2, 5 do
    if suits[i] ~= suits[1] then
      return false
    end
  end
  return true
end

function isFourOfAKind(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2)
  local values = { getCardValue(fcard1), getCardValue(scard1), getCardValue(tcard1), getCardValue(foucard1), getCardValue(
    fifcard1) }
  table.sort(values)
  for i = 4, #values do
    if values[i] == values[i - 1] and values[i - 1] == values[i - 2] and values[i - 2] == values[i - 3] then
      return true
    end
  end
  return false
end

function isFullHouse(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2)
  return (isThreeOfAKind(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2) and isTwoPair(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2) and not isFourOfAKind(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2))
end

function isFlush(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2)
  local suits = { getSuitValue(fcard2), getSuitValue(scard2), getSuitValue(tcard2), getSuitValue(foucard2), getSuitValue(
    fifcard2) }
  for i = 2, #suits do
    if suits[i] ~= suits[1] then
      return false
    end
  end
  return true
end

function straight(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2)
  local values = { getCardValue(fcard1), getCardValue(scard1), getCardValue(tcard1), getCardValue(foucard1), getCardValue(
    fifcard1) }
  table.sort(values)
  for i = 2, #values do
    if values[i] ~= values[i - 1] + 1 then
      return false
    end
  end
  return true
end

function isThreeOfAKind(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2)
  local values = { getCardValue(fcard1), getCardValue(scard1), getCardValue(tcard1), getCardValue(foucard1), getCardValue(
    fifcard1) }
  table.sort(values)
  for i = 3, #values do
    if values[i] == values[i - 1] and values[i - 1] == values[i - 2] then
      return true
    end
  end
  return false
end

function isTwoPair(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2)
  local values = { getCardValue(fcard1), getCardValue(scard1), getCardValue(tcard1), getCardValue(foucard1), getCardValue(
    fifcard1) }
  table.sort(values)
  local count = 0
  local i = 2
  while i <= #values do
    if values[i] == values[i - 1] then
      count = count + 1
      i = i + 1
    end
    i = i + 1
  end
  if count >= 2 then
    return true
  else
    return false
  end
end

function isPair(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2)
  local values = { getCardValue(fcard1), getCardValue(scard1), getCardValue(tcard1), getCardValue(foucard1), getCardValue(
    fifcard1) }
  table.sort(values)
  for i = 2, #values do
    if values[i] == values[i - 1] then
      return true
    end
  end
  return false
end

function getBestCombination(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2)
  if isRoyalFlush(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2) then
    return 9
  elseif isStraightFlush(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2) then
    return 8
  elseif isFourOfAKind(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2) then
    return 7
  elseif isFullHouse(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2) then
    return 6
  elseif isFlush(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2) then
    return 5
  elseif straight(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2) then
    return 4
  elseif isThreeOfAKind(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2) then
    return 3
  elseif isTwoPair(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2) then
    return 2
  elseif isPair(fcard1, fcard2, scard1, scard2, tcard1, tcard2, foucard1, foucard2, fifcard1, fifcard2) then
    return 1
  end
end

function getWinner(players)
  for i = 1, #players do
    local num = 0
    local hand = { players[i][1], players[i][2], players[i][3], players[i][4], poolCards[1], poolCards[2], poolCards[3],
      poolCards[4], poolCards[5], poolCards[6], poolCards[7], poolCards[8], poolCards[9], poolCards[10] }
    for a = 1, 3 do
      for b = a + 1, 4 do
        for c = b + 1, 5 do
          for d = c + 1, 6 do
            for e = d + 1, 7 do
              num = math.max(num,
                getBestCombination(hand[a * 2 - 1], hand[a * 2], hand[b * 2 - 1], hand[b * 2], hand[c * 2 - 1],
                  hand[c * 2], hand[d * 2 - 1], hand[d * 2], hand[e * 2 - 1], hand[e * 2]))
            end
          end
        end
      end
    end
    table.insert(detWinner, num)
    if (i == 1) then
      if (num == 9) then
        print("You received a royal flush")
      elseif (num == 8) then
        print("You received a straight flush")
      elseif (num == 7) then
        print("You received a four of a kind")
      elseif (num == 6) then
        print("You received a full house")
      elseif (num == 5) then
        print("You received a flush")
      elseif (num == 4) then
        print("You received a straight")
      elseif (num == 3) then
        print("You received a three of a kind")
      elseif (num == 2) then
        print("You received a two pair")
      elseif (num == 1) then
        print("You received a pair")
      else
        print("You received a high card")
      end
    else
      if (num == 9) then
        print("Bot " .. i - 1 .. " has a royal flush")
      elseif (num == 8) then
        print("Bot " .. i - 1 .. " has a straight flush")
      elseif (num == 7) then
        print("Bot " .. i - 1 .. " has a four of a kind")
      elseif (num == 6) then
        print("Bot " .. i - 1 .. " has a full house")
      elseif (num == 5) then
        print("Bot " .. i - 1 .. " has a flush")
      elseif (num == 4) then
        print("Bot " .. i - 1 .. " has a straight")
      elseif (num == 3) then
        print("Bot " .. i - 1 .. " has a three of a kind")
      elseif (num == 2) then
        print("Bot " .. i - 1 .. " has a two pair")
      elseif (num == 1) then
        print("Bot " .. i - 1 .. " has a pair")
      else
        print("Bot " .. i - 1 .. " has high card")
      end
    end
  end
end

io.write("How many other players are in the game?")
deck.makeDeck()
local num = io.read()
local yourCard1 = deck.pickRandomCard()
local yourCard2 = deck.pickRandomCard()
table.insert(players, { yourCard1[1], yourCard1[2], yourCard2[1], yourCard2[2] })
print("Your cards are " .. yourCard1[1] .. " of " .. yourCard1[2] .. " and " .. yourCard2[1] .. " of " .. yourCard2
  [2])
print("")
for a = 2, num + 1 do
  local card1 = deck.pickRandomCard()
  local card2 = deck.pickRandomCard()
  table.insert(players, { card1[1], card1[2], card2[1], card2[2] })
  print("Bot " ..
    a - 1 ..
    " recieved a " .. players[a][1] .. " of " .. players[a][2] .. " and a " .. players[a][3] .. " of " .. players[a][4])
  print("")
end
local card1 = deck.pickRandomCard()
local card2 = deck.pickRandomCard()
local card3 = deck.pickRandomCard()
local card4 = deck.pickRandomCard()
local card5 = deck.pickRandomCard()
poolCards = { card1[1], card1[2], card2[1], card2[2], card3[1], card3[2], card4[1], card4[2], card5[1], card5[2] }

print("Cards on table:")
for i = 1, 10, 2 do
  print(poolCards[i] .. " of " .. poolCards[i + 1])
end
print("")
getWinner(players)
local max = 0
local winner = 0
for z = 1, #detWinner do
  if max < detWinner[z] then
    max = detWinner[z]
    winner = z
  end
end
print("")
print("")
if (winner == 1) then
  print("You won the game!")
else
  print("You lost, bot " .. winner - 1 .. " won the game :(")
end
print("")
