using System;
using System.Collections.Generic;
using UnityEngine;

namespace NarrativeEvents.Data
{
    [CreateAssetMenu(fileName = "NarrativeSheet", menuName = "Events/NarrativeSheet", order = 0)]
    public class NarrativeSheet : ScriptableObject
    {
        [SerializeField] private List<Evento> _events;
    }

    [Serializable]
    public class Evento
    {
        [SerializeField, TextArea] private string _description;
        [SerializeField] private List<Decision> _decisions;
    }
    
    [Serializable]
    public class Decision
    {
        [SerializeField, TextArea] private string _description;

        [SerializeField, TextArea] private List<string> _consequences;
    }
}