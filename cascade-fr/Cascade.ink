+ [Sortir du souterrain]
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

<:me>Vous</> êtes dans {une|la} caverne derrière {une|la} <:cascade>cascade</>. {Au sud se trouve le souterrain que vous venez de traverser.|} Au nord l’epais rideau d’eau de la cascade barre votre chemin. {Vous êtes épuisée, toute crottée et votre plus grand rêve est de prendre une douche.|}
    {knows( know_alcove, indistinct):
    En actionnant le mecanisme de la cascade, un vantail s’est ouvert qui éclaire {not_yet(know_alcove,seen):la <:paroi>paroi</> rocheuse | la <:paroi>petite alcove</>}.
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
<:me>Vous</> etes sur un <:promontoire>promontoire</> devant l’ouverture de la <:caverne>caverne</> que cachait la cascade au sud. En <:contrebas>contrebas</>, le profond bassin s’est vidé. La <:jungle>jungle</> forme un mur épais d'arbres au-delà du précipice. 
    {knows(know_singe, seen):Le <:singe>singe</> vous observe {BolInventory has biscuit:avec excitation|incrédule}. {SingeInventory has clef  and knows(know_singe, studied):Il porte une <:clef>clé</> autour du cou.}}
    {actions_bol.seen_bol: Au sol le petit <:bol>bol naturel</> {LIST_COUNT(BolInventory) > 0: contient {listWithCommasAnd(BolInventory, "")}| est vide.}}

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
+{came_from(->select_contrebas)} [Sauter]
    Vous sautez. Vous regrettez amèrement ce choix lorsque vous heurtez votre orteil et vous brisez le reste de vos os sur les pierres et que le bassin se remplit à nouveau, vous noyant irremediablement. #actionscalie
    ++ [Recommencer] 
        Si l'histoire ne redémarre pas, rafraîchissez la page. #reset
    --
    ->END


=== actions_me(->then)
    + [envchoice: me]
        {Crevée. À bout. Des heures que vous marchez dans la jungle. |} Vous ne rêvez que d'une bonne douche. #didascalie
        Vous portez {listWithCommasAnd(Inventory, "la solitude du monde sur vos épaules")}. # didascalie
        <-listInventory(Inventory, then)
        -> then


=== actions_cascade(->then)
    +{lockState == unlocked}[actchoice: Aller au nord] Vous avancez vers la cascade. #actionscalie
        Au moment où vous vous apprêtez à passer dessous, elle s'interrompt. #actionscalie
        Vous enjambez l'espace où s'écoulait la cascade quelques instants auparavant vers un rocher plat. # actionscalie
        {{itemize("caverne","Derrière vous")}, un léger cliquetis se fait entendre. |}#didascalie
        ~position = (outside)
        -> Promontoire
    +{lockState == locked}[actchoice: Aller au nord] Vous avancez vers la cascade. #actionscalie
        Mais cette fois-ci, au moment où vous vous apprêtez à passer dessous, elle continue à couler. #actionscalie
        Voilà la douche que vous attendiez ! #actionscalie
        Une fois rincée, vous sortez et traversez le bassin à la nage. # didascalie
        Bravo, vous avez gagné ! #didascalie
        ++ [Recommencer] 
            Si l'histoire ne redémarre pas, rafraîchissez la page. #reset
        --
        ->END

=== actions_paroi(->then)
    +[actchoice: Examiner] 
        ~temp NbItem = LIST_COUNT(AlcoveInventory)
        Une alcove est creusée dans la paroi. {NbItem > 0: S’y trouve{NbItem > 1:nt} {listWithCommasAnd(AlcoveInventory, "")}|Elle est vide}. #didascalie
        {knows(know_serrure,seen): <> On distingue une petite <:serrure>serrure</>  creusée dans la roche.}
        <-listInventory(AlcoveInventory, then)
        -> then

=== actions_serrure(->then)
    +[actchoice: Examiner]
        C'est une petite serrure avec deux positions. #didascalie
        -> then
    +{Inventory has biscuit}[actchoice: Insérer biscuit]
        Le biscuit est trop grossier pour rentrer dans la serrure. #didascalie
        -> then
    +{Inventory has clef}[actchoice: Insérer petite clé]
        Vous insérez la clé dans la serrure et tournez d'un quart de tour. #didascalie
        Un cliquetis mécanique indique que tout s'est bien passé. #didascalie
        ~lockState = (locked)
        -> then

=== actions_boite(->then)
    +[actchoice: Examiner] 
        Vous observez la boîte. Sur le couvercle est dessiné un petit train à vapeur conduit par un singe. #didascalie
        -> then
    +{Inventory hasnt boite}[actchoice: Prendre] 
        Vous prenez la petite boîte. #didascalie
        ~AlcoveInventory -= boite
        ~Inventory+= boite
        Vous decouvrez une petite serrure percée dans la roche juste en dessous. #didascalie
        ~know_serrure = (seen)
        ->then
    +[actchoice: Ouvrir] 
        Vous ouvrez la boîte.{BoiteInventory has biscuit: Elle contient un <:biscuit>biscuit</> en forme de clé.|Elle est vide} #didascalie
        {BoiteInventory has biscuit:<-listInventory((biscuit), then)}
        -> then
=== actions_clef(->then)
    +{Inventory has clef or BolInventory has clef}[actchoice: Examiner] 
        C'est une petite clé en or. Elle ressemble à celles qu'ont les dépanneurs d'ascenseurs. #didascalie
        -> then
    +{SingeInventory has clef}[actchoice: Observer] 
        C'est une petite clé en or. #didascalie
        -> then
    +{SingeInventory has clef}[actchoice: Prendre] 
        Elle est inaccessible ! #didascalie
        -> then
    +{BolInventory has clef}[actchoice: Prendre] 
        Vous prenez la clé ! #didascalie
        ~BolInventory -= clef
        ~Inventory += clef
        ->then
=== actions_vuvuzela(->then)
    +[actchoice: Examiner] 
        D'atroces souvenirs de la Coupe du Monde 2010 réveillent vos acouphènes. #didascalie
        -> then
    +{Inventory hasnt vuvuzela}[actchoice: Prendre] 
        Vous prenez la vuvuzela. #didascalie
        ~AlcoveInventory -= vuvuzela
        ~Inventory+= vuvuzela
        ->then
    +{Inventory has vuvuzela}[actchoice: Souffler] 
        Le son qui sort de la trompette est {~atroce|insupportable|intolérable|infernal|épouvantable|intenable|énervant}. #didascalie
        {position == outside && not_yet(know_singe, seen):
            {knows(know_singe, indistinct):Le|Un} {itemize("singe", "singe")} se reveille et vous regarde, incredule. #actionscalie
            ~know_singe += (seen)
        }
        -> then
=== actions_biscuit(->then)
    +[actchoice: Examiner] 
        C'est un <:biscuit>biscuit</> en forme de clé. #didascalie
        <-listInventory((biscuit), then)
        -> then
    +{BoiteInventory has biscuit}[actchoice: Prendre] 
        Vous prenez le <:biscuit>biscuit</>. #didascalie
        ~BoiteInventory = ()
        ~Inventory+=(biscuit)
        <-listInventory((biscuit), then)
        -> then
    +[actchoice: Sentir] 
        Une écœurante odeur de banane émane du <:biscuit>biscuit</>. #didascalie
        <-listInventory((biscuit), then)
        -> then
    +[actchoice: Manger] 
        Vous approchez le <:biscuit>biscuit</> de votre bouche mais une odeur de banane écœurante vous empêche d'aller plus loin. #didascalie
        <-listInventory((biscuit), then)
        -> then


=== actions_promontoire(->then)
+ [actchoice: Observer]
    Le promontoire a la taille d'un carré d'environ 90cm de côté. {Lorsque le bassin est rempli, il dépasse sûrement de la surface d'une quinzaine de centimètres.|} Au centre la force de l'érosion a creusé une petite <:bol>dépression</>. #didascalie
    ->then


=== actions_bol(->then)
    + (seen_bol)[actchoice: Observer]
        On dirait presque un petit bol dans lequel on pourrait déposer quelquechose. # didascalie
        ->then
    +(dispose){seen_bol}[actchoice: Déposer]
        Que voulez-vous déposer dans le bol ? # didascalie
        <-disposeInventory(Inventory, then)
        ->then
    +{LIST_COUNT(BolInventory) >0 }[actchoice: Prendre]
        Vous prenez {verbose("le", BolInventory)}. #didascalie
        ~Inventory += BolInventory
        ~BolInventory = ()
        -> then

=== actions_caverne(->then)
    +{position == outside} [actchoice: Aller au sud] Vous avancez vers la cascade. #actionscalie
        Au moment où vous pénétrez dans la caverne, elle reprend son cours. #actionscalie
        ~position = (inside)
        ~know_alcove += (indistinct)
        {<> Vous remarquez une nouvelle source lumineuse.|}
        {knows(know_singe, seen) and BolInventory has biscuit:
            - Vous espérez que le singe a compris la stratégie. #actionscalie
              ~know_singe = (archived)
              ~SingeInventory = ()
              ~BolInventory = ()
              ~BolInventory += clef
        }
        -> Cascade

=== actions_jungle(->then)
    +[actchoice: Observer] 
        {
            - knows(know_singe, archived): Le singe a réintégré le hamac et semble se régaler de son biscuit.#didascalie
            - knows(know_singe, studied): Le hamac est désormais vide entre les arbres.#didascalie
            -knows( know_singe, seen): Le hamac est désormais vide entre les arbres.#didascalie
            - knows(know_singe, indistinct): Le singe est toujours endormi dans son hamac.#didascalie
            - knows(know_singe, unknown): En observant les arbres vous remarquez un <:singe>singe</> endormi dans un hamac.#didascalie
                ~know_singe=(indistinct)
        }
        -> then

=== actions_singe(->then)
    +[actchoice: Observer] 
        {
            - knows(know_singe, archived): Vous ne distinguez que son museau dans le hamac. #didascalie
            - knows(know_singe, studied): Le singe vous regarde avec attention, {SingeInventory has clef:sa <:clef>petite clé</> toujours autour du cou.} #didascalie
            - knows(know_singe, seen): Le singe vous regarde avec attention. {SingeInventory has clef: Vous remarquez qu'il a une <:clef>petite clé</> en or autour du cou.} #didascalie
                ~know_singe += studied
            - knows(know_singe, indistinct): Vous ne distinguez que son museau. #didascalie
            
        }
        {knows(know_singe, seen) and BolInventory has biscuit: <>Il regarde dans votre direction avec excitation.}
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
    - boite: {det=="un":une|la} {itemize(term,"boîte en fer blanc")}
    - clef: {det=="un":une|la} {itemize(term,"petite clé en or")}
    - vuvuzela: {det=="un":une|la} {itemize(term,"vuvuzela")}
    - biscuit: {det=="un":un|le} {itemize(term,"biscuit")}
    - else: {term}
    }

=== function raw_verbose(term)
    {term:
    - boite: La boîte en fer blanc
    - clef: La petite clé en or
    - vuvuzela: La vuvuzela
    - biscuit: Le biscuit
    - else: Le {term}
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
        	{verbose("un", LIST_MIN(list))} et {listWithCommasAnd(list - LIST_MIN(list), if_empty)}
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
            Que voulez-vous faire avec {verbose("le", current_ctc)} ? # didascalie
            ~temp divert = divert_inventory(current_ctc)
            ->divert(next)
        
    } 

=== disposeInventory(list, ->next)
    ~ temp current_ctc = LIST_MIN(list)
    
    { LIST_COUNT(list) > 0 :
        <- disposeInventory(list - current_ctc, next)
        +{came_from(->actions_bol.dispose)}[actchoice: {raw_verbose(current_ctc)}]
            {LIST_COUNT(BolInventory) > 0:
                - Vous reprenez d'abord {verbose("le", BolInventory)}. <>
                    ~ Inventory += BolInventory
                    ~ BolInventory = ()
            }
            Vous déposez {verbose("le", current_ctc)} dans la dépression naturelle au centre du promontoire. # didascalie
            ~BolInventory += current_ctc
            ~Inventory-=current_ctc
            {current_ctc == biscuit and knows(know_singe, seen): <> Le <:singe>singe</> émet un petit sifflement.}
            -> next
        
    } 

=== function knows(mylist, item)
    ~ return LIST_MAX(mylist) >= item

=== function not_yet(mylist, item)
    ~ return LIST_MAX(mylist) < item
