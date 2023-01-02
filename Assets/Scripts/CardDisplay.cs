using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CardDisplay : MonoBehaviour
{
    public Card card;
    public Text nametext;
    public Text descriptionText;
    public Image artworkImage;
    public Text typeText;
    public Text tierText;
    public Text activationText;
    public Text standingText;
    public Text dismissText;
    public List<Color> colourOverly;
    public List<Image> SubtypeImage;
    


    private void Awake()
    {
        nametext.text = card.name;
        descriptionText.text = card.description;
        artworkImage.sprite = card.artwork;
        tierText.text = card.tier.ToString();
        for(int i=0; i < card.activationCost.Count-1; i++)
        {
            activationText.text += i.ToString() + "/";
        }//end write full list to string
        activationText.text += card.activationCost[card.activationCost.Count-1].ToString();
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
