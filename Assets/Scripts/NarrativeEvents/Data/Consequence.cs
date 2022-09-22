using System.Collections.Generic;
using TNRD;
using UnityEngine;
using UnityEngine.Localization;

namespace NarrativeEvents.Data
{
    [CreateAssetMenu(fileName = "Consequence", menuName = "Events/Consequence", order = 0)]
    public class Consequence : ScriptableObject
    {
        [SerializeField] private LocalizedString _description;
        [SerializeField] private Sprite _image;
        [SerializeField] private List<SerializableInterface<IConsequence>> _consequences;

        public LocalizedString Description => _description;

        public Sprite Image => _image;

        private List<IConsequence> Consequences => _consequences.ConvertAll(consequence => consequence.Value);

        public void ExecuteConsequences()
        {
            Consequences.ForEach(consequence => consequence.Execute());
        }
    }
}