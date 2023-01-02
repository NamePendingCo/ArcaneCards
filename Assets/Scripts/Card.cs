using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//Colour definitions for every card
public enum Colour { 
    Red, Orange, Yellow, Green, Blue, Purple, Gray 
}//end Colour

//List of subtypes for every colour
public enum Subtype
{
    Heat, Freeze, Elecricity, Nuclear, 
    Chemical, Poison, Disease, Transmutation, 
    Blast, Pressure, Vibration, Kinesis,
    Nature, Storage, Draining, Release,
    Illusion, MindBreaking, MindControl, MindReading,
    Light, Dark, Spirit, Oblivion
}//end Subtype
//Card type
public enum CardType { 
    INSTANT, STANDING, WARD, REACTION, FIELD 
}//end CardType

public abstract class Card : ScriptableObject { 
    [Header("Aesthetics")]
    //name is used in Unity for Object.name, new bypasses this.
    public new string name;
    [TextArea] public string description;
    public Sprite artwork;

    [Header("Mechanics")]
    public List<Colour> colour;
    [HideInInspector] public List<Subtype> subField;
    [Range(1,3)] public int tier;
    [HideInInspector] public List<int> activationCost = new List<int>();
    [HideInInspector] public List<int> selections = new List<int>();
}//end Card abstract

[CreateAssetMenu(fileName = "New Instant Card", menuName = "Card/Instant Card")]
public class InstantCard : Card
{
    [HideInInspector] readonly CardType type = CardType.INSTANT;
}//end Instant Card Object

[CreateAssetMenu(fileName = "New Standing Card", menuName = "Card/Standing Card")]
public class StandingCard : Card
{
    [HideInInspector] readonly CardType type = CardType.STANDING;
    public int standingCost;
    public int dismissCost;
}//end Standing Card object

[CreateAssetMenu(fileName = "New Ward Card", menuName = "Card/Ward Card")]
public class WardCard : Card
{
    [HideInInspector] readonly CardType type = CardType.WARD;
    public int standingCost;
    public int dismissCost;
}//end Standing Card object

[CreateAssetMenu(fileName = "New Reaction Card", menuName = "Card/Reaction Card")]
public class ReactionCard : Card
{
    [HideInInspector] readonly CardType type = CardType.REACTION;
}//end Standing Card object

[CreateAssetMenu(fileName = "New Field Card", menuName = "Card/Field Card")]
public class FieldCard : Card
{
    [HideInInspector] readonly CardType type = CardType.FIELD;
    public int standingCost;
    public int dismissCost;
}//end Standing Card object


