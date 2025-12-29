+ [Leave the tunnel]
    -> Cascade

LIST seen_state = unknown, indistinct, seen, studied, archived

LIST Items = boite, clef, vuvuzela, biscuit
VAR Inventory = ()
VAR AlcoveInventory = (boite, vuvuzela)
VAR BoiteInventory = (biscuit)
VAR SingeInventory = (clef)
VAR BolInventory = ()

VAR know_alcove = (unknown)
VAR know_cascade = (seen)
VAR know_promontoire = (unknown)
VAR know_serrure = (unknown)
VAR know_singe = (unknown)
VAR know_clef = (unknown)

LIST position = (inside), outside
LIST lockState = (unlocked), locked


=== Cascade

<:me>You</> are in {a|the} cavern behind {a|the} <:cascade>waterfall</>. {South is the maze of tunnels you just escape.|} North, the thick curtain of water of the waterfall blocks the way. {You are exhausted, covered in mud and your biggest dream right now is to have a shower.|}
    {knows( know_alcove, indistinct):
    {When you trigered the waterfall mechanism, an opening has been created that {now |}|An hidden opening from above} lights {not_yet(know_alcove,seen):the <:paroi>wall</> | the <:paroi>small alcove</>}.
    }

{came_from(->select_cascade): <-actions_cascade(-> Cascade)}
{came_from(->select_paroi): <-actions_paroi(-> Cascade)}
{came_from(->select_serrure): <-actions_serrure(-> Cascade)}

 <-actions_me(->Cascade)
 <-actions_inventory(->Cascade)
 + (select_cascade) [envchoice: cascade]
        ~ know_cascade += studied
        -> Cascade
+ (select_serrure) [envchoice: serrure]
        -> Cascade
+ (select_paroi) [envchoice: paroi]
        ~ know_alcove += studied
        -> Cascade



=== Promontoire
<:me>You</> are on a <:promontoire>boulder</> in front of the opening leading to the <:caverne>cavern</> that the waterfall hid. Down <:contrebas>below</>, you can see the deep bottom of the pool, which is now empty. The thick wall of trees of the <:jungle>jungle</> surrounds you beyond the precipice. 
    {knows(know_singe, seen):The <:singe>monkey</> looks at you {BolInventory has biscuit:excitedly|incredously}. {SingeInventory has clef and knows(know_singe, studied):It holds a <:clef>key</> around its neck.}}
    {actions_bol.seen_bol: On the ground, the small <:bol>natural bowl</> {LIST_COUNT(BolInventory) > 0: holds {listWithCommasAnd(BolInventory, "")}| is empty.}}

{came_from(->select_promontoire): <-actions_promontoire(-> Promontoire)}
{came_from(->select_caverne): <-actions_caverne(-> Promontoire)}
{came_from(->select_jungle): <-actions_jungle(-> Promontoire)}
{came_from(->select_singe): <-actions_singe(-> Promontoire)}
{came_from(->select_bol): <-actions_bol(-> Promontoire)}
{knows(know_clef,seen): <-listInventory((clef), ->Promontoire)}
<-actions_me(->Promontoire)
<-actions_inventory(->Promontoire)
+ (select_promontoire) [envchoice: promontoire]
    -> Promontoire
+ (select_caverne) [envchoice: caverne]
    -> Promontoire
+ (select_jungle) [envchoice: jungle]
    ->Promontoire
+ (select_contrebas) [envchoice: contrebas]
    ->Promontoire
+ (select_bol) [envchoice: bol]
    ->Promontoire
+ (select_singe) [envchoice: singe]
    ->Promontoire
+{came_from(->select_contrebas)} [Jump]
    You bitterly regret this choice when you stub your toe and break the rest of your bones on the rocks, and the tank fills up again, irrevocably drowning you. #actionscalie
    ++ [Restart] 
        If the story does not restart, please refresh the page. #reset
    --
    ->END


=== actions_me(->then)
    + [envchoice: me]
        {Exhausted. Worn out. Hours of stumbling on that damn maze. |} Your only dream is of a shower. #didascalie
        You hold {listWithCommasAnd(Inventory, "the weight of the world on your shoulders")}. # didascalie
        <-listInventory(Inventory, then)
        -> then


=== actions_cascade(->then)
    +{lockState == unlocked}[actchoice: Go north] You walk towards the waterfall.. #actionscalie
        Just as you are about to pass underneath, it stops. #actionscalie
        You step over the space where the waterfall was flowing just moments before, toward a flat boulder. # actionscalie
        {{itemize("caverne","Behind you")}, a faint clicking sound can be heard. |}#didascalie
        ~position = (outside)
        -> Promontoire
    +{lockState == locked}[actchoice: Go north] You walk towards the waterfall.. #actionscalie
        But this time, just as you are about to pass underneath, it continues to flow. #actionscalie
        Here's the shower you've been waiting for! #actionscalie
        Once you have rinsed off, you get out and swim across the pool. # didascalie
        Congratulations, you've won! #didascalie
        ++ [Restart] 
            If the story does not restart, please refresh the page. #reset
        --
        ->END

=== actions_paroi(->then)
    +[actchoice: Examine] 
        ~temp NbItem = LIST_COUNT(AlcoveInventory)
        {An|The} alcove is carved into the wall. {NbItem > 0: You can see {listWithCommasAnd(AlcoveInventory, "")} in it|It's empty}. #didascalie
        {knows(know_serrure,seen): <> A small <:serrure>keyhole</> chiselled into the rock is visible.}
        <-listInventory(AlcoveInventory, then)
        -> then

=== actions_serrure(->then)
    +[actchoice: Examine]
        That's a keyhole with two position. #didascalie
        -> then
    +{Inventory has biscuit}[actchoice: Insert biscuit]
        The cookie is too big to fit in the keyhole. #didascalie
        -> then
    +{Inventory has clef}[actchoice: Insert small key]
        You insert the key into the keyhole and turn it a quarter turn. #didascalie
        A mechanical clicking sound indicates that everything went well. #didascalie
        ~lockState = (locked)
        -> then

=== actions_boite(->then)
    +[actchoice: Examine] 
        You look at the <:boite>box</>. On the lid is a drawing of a small steam train driven by a monkey. #didascalie
        <-listInventory((boite), then)
        -> then
    +{Inventory hasnt boite}[actchoice: Take] 
        You take the small <:boite>box</>. #didascalie
        ~AlcoveInventory -= boite
        ~Inventory+= boite
        You discover a small keyhole chiseled into the rock underneath. #didascalie
        ~know_serrure = (seen)
        <-listInventory((boite), then)
        ->then
    +[actchoice: Open] 
        You open the <:boite>box</>. {BoiteInventory has biscuit: It contains a key-shaped <:biscuit>biscuit</>.|It's empty.} #didascalie
        {BoiteInventory has biscuit:<-listInventory((biscuit), then)}
        <-listInventory((boite), then)
        -> then
=== actions_clef(->then)
    +{Inventory has clef or BolInventory has clef}[actchoice: Examine] 
        It is a small golden key. It looks like the ones that elevator repairmen have.. #didascalie
        -> then
    +{SingeInventory has clef}[actchoice: Look] 
        It is a small golden key. #didascalie
        -> then
    +{SingeInventory has clef}[actchoice: Take] 
        It's out of reach! #didascalie
        -> then
    +{BolInventory has clef}[actchoice: Take] 
        You take the key! #didascalie
        ~BolInventory -= clef
        ~Inventory += clef
        ->then
=== actions_vuvuzela(->then)
    +[actchoice: Examine] 
        Atrocious memories of the 2010 World Cup trigger your tinnitus. #didascalie
        -> then
    +{Inventory hasnt vuvuzela}[actchoice: Take] 
        You take the vuvuzela. #didascalie
        ~AlcoveInventory -= vuvuzela
        ~Inventory+= vuvuzela
        ->then
    +{Inventory has vuvuzela}[actchoice: Blow] 
        The sound that comes out of the trumpet is {~unbearable|intolerable|atrocious|hellish|appalling|untenable|annoying}. #didascalie
        {position == outside && not_yet(know_singe, seen):
            {knows(know_singe, indistinct):The|A} {itemize("singe", "monkey")} wakes up, comes to the side of the empty pool and looks at you. #actionscalie
            ~know_singe += (seen)
        }
        -> then
=== actions_biscuit(->then)
    +[actchoice: Examine] 
        It's a key-shaped <:biscuit>biscuit</>. #didascalie
        <-listInventory((biscuit), then)
        -> then
    +{BoiteInventory has biscuit}[actchoice: Take] 
        You take the <:biscuit>biscuit</>. #didascalie
        ~BoiteInventory = ()
        ~Inventory+=(biscuit)
        <-listInventory((biscuit), then)
        -> then
    +[actchoice: Smell] 
        A sickening smell of banana emanates from the <:biscuit>biscuit</>. #didascalie
        <-listInventory((biscuit), then)
        -> then
    +[actchoice: Eat] 
        You bring the <:biscuit>biscuit</> to your mouth, but a sickening smell of banana prevents you from going any further. #didascalie
        <-listInventory((biscuit), then)
        -> then


=== actions_promontoire(->then)
+ [actchoice: Look]
    The boulder has a small flat surface approximatly 90cm large. When the pool is full, it is likely to be about 15 centimeters above the surface. In the center, the erosion has carved out a small <:bol>hollow dent</>. #didascalie
    ->then


=== actions_bol(->then)
    + (seen_bol)[actchoice: Look]
        It almost looks like a small bowl in which you could place something. # didascalie
        ->then
    +(dispose){seen_bol}[actchoice: Place something]
        What would you like to place in the bowl? # didascalie
        <-disposeInventory(Inventory, then)
        ->then
    +{LIST_COUNT(BolInventory) >0 }[actchoice: Take]
        You take {verbose("le", BolInventory)}. #didascalie
        ~Inventory += BolInventory
        ~BolInventory = ()
        -> then

=== actions_caverne(->then)
    +{position == outside} [actchoice: Go south] You walk towards the waterfall.. #actionscalie
        The moment you enter the cavern, it resumes its flow. #actionscalie
        ~position = (inside)
        ~know_alcove += (indistinct)
        {<> You notice a new light source..|}
        {knows(know_singe, seen) and BolInventory has biscuit:
            - You hope the monkey understood the plan. #actionscalie
              ~know_singe = (archived)
              ~SingeInventory = ()
              ~BolInventory = ()
              ~BolInventory += clef
        }
        -> Cascade

=== actions_jungle(->then)
    +[actchoice: Look] 
        {
            - knows(know_singe, archived): The monkey has returned to the hammock and seems to be enjoying its biscuit. #didascalie
            - knows(know_singe, studied): The hammock is now empty between the trees. #didascalie
            -knows( know_singe, seen): The hammock is now empty between the trees. #didascalie
            - knows(know_singe, indistinct): The monkey is still asleep in its hammock. #didascalie
            - knows(know_singe, unknown): As you observe the trees, you notice a <:singe>monkey</> sleeping in a hammock. #didascalie
                ~know_singe=(indistinct)
        }
        -> then

=== actions_singe(->then)
    +[actchoice: Look] 
        {
            - knows(know_singe, archived): You can only see its snout in the hammock. #didascalie
            - knows(know_singe, studied): The monkey looks at you intently, {SingeInventory has clef:its <:clef>little key</> still around its neck.} #didascalie
            - knows(know_singe, seen): The monkey looks at you intently. {SingeInventory has clef: You notice that he has a <:clef>small key</> made of gold around his neck.} #didascalie
                ~know_singe += studied
            - knows(know_singe, indistinct): You can only see its snout. #didascalie
            
        }
        {knows(know_singe, seen) and BolInventory has biscuit: <>He looks in your direction excitedly.}
        <-listInventory((clef), then)
        ->then

=== actions_inventory(->then)
{came_from(->select_inventory.select_boite): <-actions_boite(then)}
{came_from(->select_inventory.select_clef): <-actions_clef(then)}
{came_from(->select_inventory.select_vuvuzela): <-actions_vuvuzela(then)}
{came_from(->select_inventory.select_biscuit): <-actions_biscuit(then)}
-
->DONE


=== select_inventory
    = select_boite(->then)
        ->then
    = select_clef(->then)
        ->then
    = select_vuvuzela(->then)
        ->then
    = select_biscuit(->then)
        ->then


=== function divert_inventory(item)
{item:
    -boite:  ~return ->select_inventory.select_boite
    -clef: ~return ->select_inventory.select_clef
    -vuvuzela: ~return ->select_inventory.select_vuvuzela
    -biscuit: ~return ->select_inventory.select_biscuit
}

=== function itemize(tgt, lnkname)
    <:{tgt}>{lnkname}</>

=== function verbose(det, term)
    {term:
    - boite: {det=="un":a|the} {itemize(term,"tin box")}
    - clef: {det=="un":a|the} {itemize(term,"small golden key")}
    - vuvuzela: {det=="un":a|the} {itemize(term,"vuvuzela")}
    - biscuit: {det=="un":a|the} {itemize(term,"biscuit")}
    - else: {term}
    }

=== function raw_verbose(term)
    {term:
    - boite: The tin box
    - clef: The small golden key
    - vuvuzela: The vuvuzela
    - biscuit: The biscuit
    - else: The {term}
    }

=== function came_from(-> x) 
    ~ return TURNS_SINCE(x) == 0

=== function max(a,b) ===
	{ a < b:
		~ return b
	- else:
		~ return a
	}

=== function listWithCommasAnd(list, if_empty) 
    {LIST_COUNT(list): 
    - 2: 
        	{verbose("un", LIST_MIN(list))} and {listWithCommasAnd(list - LIST_MIN(list), if_empty)}
    - 1: 
        	{verbose("un", list)}
    - 0: 
			{if_empty}	        
    - else: 
      		{verbose("un", LIST_MIN(list))}, {listWithCommasAnd(list - LIST_MIN(list), if_empty)} 
    }
    
=== listInventory(list, ->next)
    ~ temp current_ctc = LIST_MIN(list)
    
    { LIST_COUNT(list) > 0 :
        <- listInventory(list - current_ctc, next)
        +[envchoice: {current_ctc}]
            What would you like to do with {verbose("le", current_ctc)}? # didascalie
            ~temp divert = divert_inventory(current_ctc)
            ->divert(next)
        
    } 

=== disposeInventory(list, ->next)
    ~ temp current_ctc = LIST_MIN(list)
    
    { LIST_COUNT(list) > 0 :
        <- disposeInventory(list - current_ctc, next)
        +{came_from(->actions_bol.dispose)}[actchoice: {raw_verbose(current_ctc)}]
            {LIST_COUNT(BolInventory) > 0:
                - You first take {verbose("le", BolInventory)}. <>
                    ~ Inventory += BolInventory
                    ~ BolInventory = () 
            }
            You place {verbose("le", current_ctc)} in the hollow dent at the center of the boulder. # didascalie
            ~BolInventory += current_ctc
            ~Inventory-=current_ctc
            {current_ctc == biscuit and knows(know_singe, seen): <> The <:singe>monkey</> emits a small squeak.}
            -> next
        
    } 

=== function knows(mylist, item)
    ~ return LIST_MAX(mylist) >= item

=== function not_yet(mylist, item)
    ~ return LIST_MAX(mylist) < item
