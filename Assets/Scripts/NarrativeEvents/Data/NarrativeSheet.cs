using System;
using System.Collections.Generic;
using NaughtyAttributes;
using UnityEngine;

namespace NarrativeEvents.Data
{
    [CreateAssetMenu(fileName = "NarrativeSheet", menuName = "Events/NarrativeSheet", order = 0)]
    public class NarrativeSheet : ScriptableObject
    {
        [SerializeField] private List<Evento> _events;


#if UNITY_EDITOR
        [ContextMenu("Generate events")]
        private void GenerateEvents()
        {
            foreach (var @event in _events)
            {
                // obtener id (posición en lista)
                // obtener dirección de carpeta
                // ver si carpeta existe
                // si existe: obtener evento existente
                // no: crear evento y guardarlo en asset
                // ver si existe entrada en localization string table
                // si:
            }
        }
#endif
        
    }

    [Serializable]
    public class Evento
    {
        [SerializeField, Required] private string _id;
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