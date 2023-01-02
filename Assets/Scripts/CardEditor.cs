using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
#if UNITY_EDITOR
//Game will not build if it tries to run code for the unity engine which stops existing
using UnityEditor;
#endif

#region Editor
#if UNITY_EDITOR
[CustomEditor(typeof(InstantCard))]
public class ICardEditor : Editor
{
    public override void OnInspectorGUI()
    {
        //items are drawn onto the Inspector in order of the code
        //renders Unity's base fields and layout
        base.OnInspectorGUI();
        //Target created to tell Unity what object class we are editing
        Card card = (Card)target;

        EditorGUILayout.Space(20);
        EditorGUILayout.LabelField("Derived Values");
        DrawTierDynamicList(card);
        DrawSubtypeDynamicList(card);
    }//end GUI override

    static void DrawTierDynamicList(Card card)
    {
        EditorGUI.indentLevel++;
        List<int> act = card.activationCost;
        int size = Mathf.Max(1, card.tier);
        while (size > act.Count)
        {
            act.Add(0);
        }//end while tier expands list
        while (size < act.Count)
        {
            act.RemoveAt(act.Count - 1);
        }//end while tier shortens list
        for (int i = 0; i < act.Count; i++)
        {
            act[i] = EditorGUILayout.IntField("Round " + (i + 1) + " Cost", act[i]);
        }//end re-draw the list in the inspector
        EditorGUI.indentLevel--;
    }//end DrawDynamicList

    static void DrawSubtypeDynamicList(Card card)
    {
        EditorGUI.indentLevel++;
        List<Subtype> fie = card.subField;
        int size = Mathf.Max(0, card.colour.Count);
        var allTypes = Enum.GetNames(typeof(Subtype));
        List<int> sel = card.selections;
        while (size > fie.Count)
        {
            fie.Add((Subtype) 0);
            sel.Add(0);
        }//end while tier expands list
        while (size < fie.Count)
        {
            fie.RemoveAt(fie.Count - 1);
            sel.RemoveAt(sel.Count - 1);
        }//end while tier shortens list
        for (int i = 0; i < fie.Count; i++)
        {
            int min = (int) card.colour[i]*4, max = (int) (card.colour[i]+1)*4;
            var namesToDisplay = Array.FindAll(allTypes, n => Array.IndexOf(allTypes, n) >= min && Array.IndexOf(allTypes, n) < max);
            sel[i] = EditorGUILayout.Popup((card.colour[i].ToString()) + " Subtype", sel[i], namesToDisplay);
            fie[i] = (Subtype) ((int) card.colour[i]*4) + sel[i];
            //fie[i] = (Subtype) EditorGUILayout.EnumPopup((card.colour[i].ToString()) + " Subtype", fie[i]);
        }//end re-draw the list in the inspector
        EditorGUI.indentLevel--;
    }//end DrawDynamicList
}//end custom Unity Editor

[CustomEditor(typeof(StandingCard))]
public class SCardEditor : ICardEditor{}

[CustomEditor(typeof(WardCard))]
public class WCardEditor : ICardEditor {}

[CustomEditor(typeof(ReactionCard))]
public class RCardEditor : ICardEditor {}

[CustomEditor(typeof(FieldCard))]
public class FCardEditor : ICardEditor {}
#endif
#endregion
