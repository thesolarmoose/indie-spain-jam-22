using System;
using System.Collections.Generic;
using TNRD;
using UnityEngine;
using UnityEngine.Localization;
using Utils.Serializables;

namespace NarrativeEvents
{
    [CreateAssetMenu(fileName = "Event", menuName = "Events/Event", order = 0)]
    public class Event : ScriptableObject
    {
        [SerializeField] private LocalizedString _description;
        [SerializeField] private List<ConditionChoiceConsequenceTuple> _choices;

        public LocalizedString Description => _description;

        public List<ConditionChoiceConsequenceTuple> GetAvailableChoices()
        {
            return _choices.FindAll(choice => choice.Requirement.IsMet());
        }
        
    }

    [Serializable]
    public class ConditionChoiceConsequenceTuple
    {
        [SerializeField] private SerializableInterface<ISerializablePredicate> _requirement;
        [SerializeField] private Choice _choice;
        [SerializeField] private Consequence _consequence;

        public ISerializablePredicate Requirement => _requirement.Value;

        public Choice Choice => _choice;

        public Consequence Consequences => _consequence;
    }
}