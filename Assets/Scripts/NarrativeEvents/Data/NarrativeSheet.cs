using System;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace NarrativeEvents.Data
{
    [CreateAssetMenu(fileName = "NarrativeSheet", menuName = "Events/NarrativeSheet", order = 0)]
    public class NarrativeSheet : ScriptableObject
    {
        [SerializeField] private List<Evento> _events;

        public List<Evento> Events => _events;

#if UNITY_EDITOR
        [ContextMenu("Clear ids")]
        private void ClearIds()
        {
            foreach (var @event in _events)
            {
                @event.Id = "";
            }
            EditorUtility.SetDirty(this);
        }

        [ContextMenu("Print ids")]
        private void PrintIds()
        {
            var ids = _events.ConvertAll(e => e.Id);
            var existDuplicated = ids.Count != ids.Distinct().Count();
            Debug.Log($"duplicated: {existDuplicated}");
            Debug.Log(string.Join("\n", ids));
        }
#endif
        
    }

    [Serializable]
    public class Evento
    {
        [SerializeField, TextArea] private string _description;
        [SerializeField] private List<Decision> _decisions;
        [SerializeField, HideInInspector] private string _id;

        public string Id
        {
            get => _id;
            set => _id = value;
        }

        public string Description => _description;

        public List<Decision> Decisions => _decisions;
    }
    
    [Serializable]
    public class Decision
    {
        [SerializeField, TextArea] private string _description;

        [SerializeField, TextArea] private List<string> _consequences;

        public string Description => _description;

        public List<string> Consequences => _consequences;
    }
}